import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 12: Interactive Profile & Identity Centered Navigation.
///
/// Centered identity layout with prominent avatar and metadata chips that smoothly
/// scale-morphs and translates into an aligned left avatar slot alongside compact
/// title in the pinned toolbar.
class ProfileIdentityConfig extends AppBarModelConfiguration {
  /// Creates a [ProfileIdentityConfig].
  const ProfileIdentityConfig({
    this.userName = 'Dr. Eleanor Vance',
    this.userHandle = '@eleanor_vance',
    this.verified = true,
    this.avatarWidget,
    this.bio = 'Principal Systems Architect • Cloud Core',
    this.statChips = const ['4.2k Followers', '280 Repos', 'PRO Tier'],
    this.expandedAvatarSize = 72.0,
    this.collapsedAvatarSize = 32.0,
    this.expandedHeight = 210.0,
    this.collapsedHeight = 60.0,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Full display name of the user or entity.
  final String userName;

  /// User account handle string.
  final String userHandle;

  /// Whether to render a verified check badge next to the username.
  final bool verified;

  /// Optional custom avatar widget override.
  final Widget? avatarWidget;

  /// Short bio or subtitle description.
  final String? bio;

  /// Informational pill chips rendered below the profile name.
  final List<String> statChips;

  /// Diameter of the avatar circle in expanded resting state.
  final double expandedAvatarSize;

  /// Diameter of the avatar circle in collapsed pinned state.
  final double collapsedAvatarSize;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed height of the pinned toolbar.
  final double collapsedHeight;
}
