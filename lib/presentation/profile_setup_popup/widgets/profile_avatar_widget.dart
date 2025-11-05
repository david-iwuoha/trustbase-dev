import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileAvatarWidget extends StatefulWidget {
  final Function(XFile?) onImageSelected;
  final XFile? selectedImage;

  const ProfileAvatarWidget({
    Key? key,
    required this.onImageSelected,
    this.selectedImage,
  }) : super(key: key);

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _showCameraPreview = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      // Handle camera initialization error silently
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    if (_cameras.isEmpty) return;

    final camera = kIsWeb
        ? _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => _cameras.first)
        : _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras.first);

    _cameraController = CameraController(
        camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

    try {
      await _cameraController!.initialize();
      await _applySettings();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      // Handle initialization error silently
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      // Ignore focus mode errors
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        // Ignore flash mode errors on unsupported devices
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageSelected(photo);
      setState(() {
        _showCameraPreview = false;
      });
    } catch (e) {
      // Handle capture error silently
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        widget.onImageSelected(image);
      }
    } catch (e) {
      // Handle gallery picker error silently
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      'Select Photo Source',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSourceOption(
                          icon: 'camera_alt',
                          label: 'Camera',
                          onTap: () async {
                            Navigator.pop(context);
                            if (await _requestCameraPermission()) {
                              await _initializeCamera();
                              setState(() {
                                _showCameraPreview = true;
                              });
                            }
                          },
                        ),
                        _buildSourceOption(
                          icon: 'photo_library',
                          label: 'Gallery',
                          onTap: () {
                            Navigator.pop(context);
                            _pickFromGallery();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 8.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      );
    }

    return Container(
      height: 60.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CameraPreview(_cameraController!),
          ),
          Positioned(
            bottom: 4.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCameraButton(
                  icon: 'close',
                  onTap: () {
                    setState(() {
                      _showCameraPreview = false;
                    });
                  },
                ),
                _buildCameraButton(
                  icon: 'camera',
                  onTap: _capturePhoto,
                  isPrimary: true,
                ),
                _buildCameraButton(
                  icon: 'flip_camera_ios',
                  onTap: () {
                    // Camera flip functionality would go here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton({
    required String icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isPrimary ? 16.w : 12.w,
        height: isPrimary ? 16.w : 12.w,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: isPrimary ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            size: isPrimary ? 8.w : 6.w,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCameraPreview) {
      return _buildCameraPreview();
    }

    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: widget.selectedImage != null
            ? ClipOval(
                child: kIsWeb
                    ? Image.network(
                        widget.selectedImage!.path,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      )
                    : CustomImageWidget(
                        imageUrl: widget.selectedImage!.path,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                        semanticLabel: "Selected profile photo",
                      ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    size: 15.w,
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        size: 4.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
