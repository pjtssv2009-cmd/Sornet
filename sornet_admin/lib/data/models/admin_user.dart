enum AdminRole {
  superAdmin,
  admin,
  verificationManager,
  supportManager,
  operationsManager,
  marketingManager;

  String get displayName {
    switch (this) {
      case AdminRole.superAdmin:
        return 'Super Admin';
      case AdminRole.admin:
        return 'Admin';
      case AdminRole.verificationManager:
        return 'Verification Manager';
      case AdminRole.supportManager:
        return 'Support Manager';
      case AdminRole.operationsManager:
        return 'Operations Manager';
      case AdminRole.marketingManager:
        return 'Marketing Manager';
    }
  }
}

class AdminPermission {
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canApprove;

  const AdminPermission({
    this.canView = true,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canApprove = false,
  });

  AdminPermission copyWith({
    bool? canView,
    bool? canCreate,
    bool? canEdit,
    bool? canDelete,
    bool? canApprove,
  }) {
    return AdminPermission(
      canView: canView ?? this.canView,
      canCreate: canCreate ?? this.canCreate,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
      canApprove: canApprove ?? this.canApprove,
    );
  }
}

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final AdminRole role;
  final String avatarUrl;
  final bool isActive;
  final DateTime lastActive;
  final Map<String, AdminPermission> permissions;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl = '',
    this.isActive = true,
    required this.lastActive,
    required this.permissions,
  });

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    AdminRole? role,
    String? avatarUrl,
    bool? isActive,
    DateTime? lastActive,
    Map<String, AdminPermission>? permissions,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      lastActive: lastActive ?? this.lastActive,
      permissions: permissions ?? this.permissions,
    );
  }
}
