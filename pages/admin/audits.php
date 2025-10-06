<?php
/**
 * Admin Audits Page
 * Manage and view all audits
 */

// Prevent direct access
if (!defined('APP_ROOT')) {
    define('APP_ROOT', dirname(__DIR__, 2));
}

require_once APP_ROOT . '/config/config.php';

$auth = getAuth();
$auth->requireAdminAccess();

$user = $auth->getCurrentUser();
$auditManager = getAuditManager();
$activityLogger = getActivityLogger();

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action'])) {
        $action = $_POST['action'];
        
        switch ($action) {
            case 'create_audit':
                $title = sanitizeInput($_POST['title']);
                $description = sanitizeInput($_POST['description']);
                $priority = sanitizeInput($_POST['priority']);
                $assigned_to = sanitizeInput($_POST['assigned_to']);
                $due_date = sanitizeInput($_POST['due_date']);
                
                $auditData = [
                    'title' => $title,
                    'description' => $description,
                    'priority' => $priority,
                    'assigned_to' => $assigned_to,
                    'due_date' => $due_date,
                    'created_by' => $user['id']
                ];
                
                $result = $auditManager->createAudit($auditData);
                if ($result) {
                    $activityLogger->log($user['id'], $user['name'], $user['role'], 'create_audit', "Created audit: {$title}");
                    $successMessage = "Audit created successfully!";
                } else {
                    $errorMessage = "Failed to create audit.";
                }
                break;
                
            case 'update_status':
                $auditId = sanitizeInput($_POST['audit_id']);
                $status = sanitizeInput($_POST['status']);
                
                $result = $auditManager->updateAuditStatus($auditId, $status);
                if ($result) {
                    $activityLogger->log($user['id'], $user['name'], $user['role'], 'update_audit_status', "Updated audit status to: {$status}");
                    $successMessage = "Audit status updated successfully!";
                } else {
                    $errorMessage = "Failed to update audit status.";
                }
                break;
        }
    }
}

// Get filters
$filters = [
    'status' => $_GET['status'] ?? '',
    'priority' => $_GET['priority'] ?? '',
    'assigned_to' => $_GET['assigned_to'] ?? '',
    'search' => $_GET['search'] ?? '',
    'page' => (int)($_GET['page'] ?? 1),
    'limit' => 20
];

// Get audits
$audits = $auditManager->getAllAudits($filters);
$auditStats = $auditManager->getAuditStats();

// Get users for assignment dropdown
$userManager = getUserManager();
$users = $userManager->getAllUsers(['role' => ['auditor', 'audit_manager']]);

// Generate CSRF token
$csrfToken = generateCSRFToken();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="<?php echo $csrfToken; ?>">
    <title>Audits - <?php echo APP_NAME; ?></title>
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>/assets/css/style.css">
    <link rel="icon" type="image/x-icon" href="<?php echo BASE_URL; ?>/favicon.ico">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2 class="text-xl font-bold text-gray-900"><?php echo APP_NAME; ?></h2>
        </div>
        <nav class="sidebar-nav">
            <a href="<?php echo BASE_URL; ?>/admin/dashboard" class="nav-link">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"></path>
                </svg>
                Dashboard
            </a>
            <a href="<?php echo BASE_URL; ?>/admin/audits" class="nav-link active">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                Audits
            </a>
            <a href="<?php echo BASE_URL; ?>/admin/users" class="nav-link">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                </svg>
                Users
            </a>
            <a href="<?php echo BASE_URL; ?>/admin/reports" class="nav-link">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                </svg>
                Reports
            </a>
            <a href="<?php echo BASE_URL; ?>/admin/activities" class="nav-link">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                </svg>
                Activities
            </a>
            <a href="<?php echo BASE_URL; ?>/admin/notifications" class="nav-link">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4 19h6v-2H4v2zM4 15h6v-2H4v2zM4 11h6V9H4v2zM4 7h6V5H4v2z"></path>
                </svg>
                Notifications
            </a>
            <a href="<?php echo BASE_URL; ?>/admin/settings" class="nav-link">
                <svg class="nav-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                </svg>
                Settings
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="content-header">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Audits</h1>
                    <p class="text-gray-600">Manage and track all audit activities</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="btn btn-primary" onclick="openCreateModal()">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
                        Create Audit
                    </button>
                    <div class="flex items-center space-x-2">
                        <span class="text-sm text-gray-600"><?php echo escapeHtml(USER_ROLES[$user['role']]); ?></span>
                        <a href="<?php echo BASE_URL; ?>/auth/logout" class="btn btn-outline btn-sm">Logout</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts -->
        <?php if (isset($successMessage)): ?>
            <div class="alert alert-success">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                </svg>
                <?php echo escapeHtml($successMessage); ?>
            </div>
        <?php endif; ?>

        <?php if (isset($errorMessage)): ?>
            <div class="alert alert-error">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                </svg>
                <?php echo escapeHtml($errorMessage); ?>
            </div>
        <?php endif; ?>

        <!-- Dashboard Content -->
        <div class="content-body">
            <!-- Stats Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="card">
                    <div class="card-content">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Total Audits</p>
                                <p class="text-3xl font-bold text-blue-600"><?php echo $auditStats['total_audits'] ?? 0; ?></p>
                            </div>
                            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">In Progress</p>
                                <p class="text-3xl font-bold text-orange-600"><?php echo $auditStats['in_progress_audits'] ?? 0; ?></p>
                            </div>
                            <div class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center">
                                <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Completed</p>
                                <p class="text-3xl font-bold text-green-600"><?php echo $auditStats['completed_audits'] ?? 0; ?></p>
                            </div>
                            <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Overdue</p>
                                <p class="text-3xl font-bold text-red-600"><?php echo $auditStats['overdue_audits'] ?? 0; ?></p>
                            </div>
                            <div class="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center">
                                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="card mb-6">
                <div class="card-content">
                    <form method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                            <select name="status" class="form-select">
                                <option value="">All Statuses</option>
                                <?php foreach (AUDIT_STATUSES as $key => $label): ?>
                                    <option value="<?php echo $key; ?>" <?php echo $filters['status'] === $key ? 'selected' : ''; ?>>
                                        <?php echo $label; ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Priority</label>
                            <select name="priority" class="form-select">
                                <option value="">All Priorities</option>
                                <?php foreach (AUDIT_PRIORITIES as $key => $label): ?>
                                    <option value="<?php echo $key; ?>" <?php echo $filters['priority'] === $key ? 'selected' : ''; ?>>
                                        <?php echo $label; ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Assigned To</label>
                            <select name="assigned_to" class="form-select">
                                <option value="">All Users</option>
                                <?php foreach ($users as $userOption): ?>
                                    <option value="<?php echo $userOption['id']; ?>" <?php echo $filters['assigned_to'] === $userOption['id'] ? 'selected' : ''; ?>>
                                        <?php echo escapeHtml($userOption['name']); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                            <input type="text" name="search" value="<?php echo escapeHtml($filters['search']); ?>" 
                                   placeholder="Search audits..." class="form-input">
                        </div>
                        <div class="md:col-span-4 flex justify-end space-x-2">
                            <button type="submit" class="btn btn-primary">Filter</button>
                            <a href="<?php echo BASE_URL; ?>/admin/audits" class="btn btn-outline">Clear</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Audits Table -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Audits</h3>
                    <p class="card-description">Manage all audit activities</p>
                </div>
                <div class="card-content">
                    <div class="overflow-x-auto">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Status</th>
                                    <th>Priority</th>
                                    <th>Assigned To</th>
                                    <th>Due Date</th>
                                    <th>Progress</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (!empty($audits)): ?>
                                    <?php foreach ($audits as $audit): ?>
                                        <tr>
                                            <td>
                                                <div>
                                                    <div class="font-medium"><?php echo escapeHtml($audit['title']); ?></div>
                                                    <div class="text-sm text-gray-500"><?php echo escapeHtml(truncateText($audit['description'], 50)); ?></div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge badge-<?php echo getStatusColor($audit['status']); ?>">
                                                    <?php echo escapeHtml(ucfirst(str_replace('_', ' ', $audit['status']))); ?>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge badge-<?php echo getPriorityColor($audit['priority']); ?>">
                                                    <?php echo escapeHtml(ucfirst($audit['priority'])); ?>
                                                </span>
                                            </td>
                                            <td><?php echo escapeHtml($audit['assigned_to_name'] ?? 'Unassigned'); ?></td>
                                            <td><?php echo formatDate($audit['due_date'], 'M j, Y'); ?></td>
                                            <td>
                                                <div class="flex items-center space-x-2">
                                                    <div class="progress w-20">
                                                        <div class="progress-bar" style="width: <?php echo $audit['progress']; ?>%"></div>
                                                    </div>
                                                    <span class="text-sm"><?php echo $audit['progress']; ?>%</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="flex space-x-2">
                                                    <button class="btn btn-sm btn-outline" onclick="viewAudit('<?php echo $audit['id']; ?>')">View</button>
                                                    <button class="btn btn-sm btn-primary" onclick="editAudit('<?php echo $audit['id']; ?>')">Edit</button>
                                                    <select class="form-select form-select-sm" onchange="updateStatus('<?php echo $audit['id']; ?>', this.value)">
                                                        <option value="">Change Status</option>
                                                        <?php foreach (AUDIT_STATUSES as $key => $label): ?>
                                                            <option value="<?php echo $key; ?>" <?php echo $audit['status'] === $key ? 'selected' : ''; ?>>
                                                                <?php echo $label; ?>
                                                            </option>
                                                        <?php endforeach; ?>
                                                    </select>
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                <?php else: ?>
                                    <tr>
                                        <td colspan="7" class="text-center py-8 text-gray-500">No audits found</td>
                                    </tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Audit Modal -->
    <div id="createModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Create New Audit</h3>
                <button class="modal-close" onclick="closeCreateModal()">&times;</button>
            </div>
            <form method="POST" class="modal-body">
                <input type="hidden" name="action" value="create_audit">
                <input type="hidden" name="csrf_token" value="<?php echo $csrfToken; ?>">
                
                <div class="form-group">
                    <label class="form-label">Title *</label>
                    <input type="text" name="title" required class="form-input">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Description *</label>
                    <textarea name="description" required rows="4" class="form-input"></textarea>
                </div>
                
                <div class="grid grid-cols-2 gap-4">
                    <div class="form-group">
                        <label class="form-label">Priority *</label>
                        <select name="priority" required class="form-select">
                            <?php foreach (AUDIT_PRIORITIES as $key => $label): ?>
                                <option value="<?php echo $key; ?>"><?php echo $label; ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Assigned To</label>
                        <select name="assigned_to" class="form-select">
                            <option value="">Select User</option>
                            <?php foreach ($users as $userOption): ?>
                                <option value="<?php echo $userOption['id']; ?>">
                                    <?php echo escapeHtml($userOption['name']); ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Due Date</label>
                    <input type="date" name="due_date" class="form-input">
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="closeCreateModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Audit</button>
                </div>
            </form>
        </div>
    </div>

    <script src="<?php echo BASE_URL; ?>/assets/js/app.js"></script>
    <script>
        function openCreateModal() {
            document.getElementById('createModal').classList.add('active');
        }
        
        function closeCreateModal() {
            document.getElementById('createModal').classList.remove('active');
        }
        
        function viewAudit(id) {
            window.location.href = '<?php echo BASE_URL; ?>/admin/audits/view/' + id;
        }
        
        function editAudit(id) {
            window.location.href = '<?php echo BASE_URL; ?>/admin/audits/edit/' + id;
        }
        
        function updateStatus(auditId, status) {
            if (!status) return;
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.innerHTML = `
                <input type="hidden" name="action" value="update_status">
                <input type="hidden" name="audit_id" value="${auditId}">
                <input type="hidden" name="status" value="${status}">
                <input type="hidden" name="csrf_token" value="<?php echo $csrfToken; ?>">
            `;
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>
