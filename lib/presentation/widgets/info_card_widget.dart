import 'package:flutter/material.dart';
import 'package:ip_locator/utils/app_constants.dart';
import 'package:ip_locator/utils/ip_location_data_utils.dart';

/// A reusable widget for displaying information in a card format
///
/// This widget creates a card with a title, icon, and a list of key-value pairs.
/// Used throughout the app to display structured information consistently.
class InfoCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<InfoItem> items;

  const InfoCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.infoCardElevation,
      child: Padding(
        padding: AppConstants.infoCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: AppConstants.iconTitleSpacing),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(),
            ...items.map((item) => _buildInfoRow(item.label, item.value)),
          ],
        ),
      ),
    );
  }

  /// Builds a row displaying a label-value pair
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppConstants.infoRowVerticalSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppConstants.infoRowLabelWidth,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value, // No business logic here - value is already formatted by ViewModel
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
