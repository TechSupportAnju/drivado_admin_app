// import 'package:drivado_admin_app/core/theme/app_colors.dart';
// import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
// import 'package:drivado_admin_app/core/widgets/app_text.dart';
// import 'package:drivado_admin_app/core/widgets/common_ui.dart';
// import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
// import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// /// Booking detail aligned with Figma summary actions (Cancel / Pay Now / invoice).
// class BookingDetailPage extends StatelessWidget {
//   const BookingDetailPage({super.key, required this.booking});

//   final ManagedBooking booking;

//   @override
//   Widget build(BuildContext context) {
//     final date =
//         DateFormat('EEE, dd MMM yyyy • HH:mm').format(booking.scheduledAt);
//     final statusLabel = switch (booking.status) {
//       BookingStatus.confirmed => 'Upcoming',
//       BookingStatus.pending => 'Pending',
//       BookingStatus.completed => 'Completed',
//       BookingStatus.cancelled => 'Cancelled',
//     };

//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: const Icon(
//                       Icons.arrow_back_rounded,
//                       color: AppColors.textOnDark,
//                     ),
//                   ),
//                   Expanded(
//                     child: AppText(
//                       'Booking Summary',
//                       align: TextAlign.center,
//                       style: AppTextStyles.subtitle,
//                       color: AppColors.textOnDark,
//                       size: 18,
//                     ),
//                   ),
//                   const SizedBox(width: 48),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: AppRoundedSheet(
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.surface,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color(0x29606060),
//                             blurRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   booking.id,
//                                   style: AppTextStyles.subtitle,
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.bookingIconBg,
//                                   borderRadius: BorderRadius.circular(40),
//                                   border: Border.all(
//                                     color: AppColors.primary.withValues(
//                                       alpha: 0.35,
//                                     ),
//                                     width: 0.5,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   statusLabel,
//                                   style: AppTextStyles.caption.copyWith(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(date, style: AppTextStyles.caption),
//                           const SizedBox(height: 16),
//                           const Divider(height: 1, color: AppColors.divider),
//                           const SizedBox(height: 16),
//                           _row('Passenger', booking.customer),
//                           _row('Trip type', booking.tripType),
//                           _row('Vehicle', booking.vehicle),
//                           _row('Passengers', '${booking.passengers}'),
//                           _row('Pickup', booking.pickup),
//                           _row('Drop-off', booking.dropoff),
//                           _row('Amount', booking.amount),
//                         ],
//                       ),
//                     ),
//                     if (booking.status == BookingStatus.confirmed ||
//                         booking.status == BookingStatus.pending) ...[
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: () {},
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: AppColors.textPrimary,
//                                 backgroundColor: AppColors.surface,
//                                 side: const BorderSide(
//                                   color: AppColors.stroke,
//                                 ),
//                                 minimumSize: const Size.fromHeight(48),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 style: AppTextStyles.button.copyWith(
//                                   color: AppColors.textPrimary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primary,
//                                 foregroundColor: Colors.white,
//                                 elevation: 0,
//                                 minimumSize: const Size.fromHeight(48),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: const Text('Pay Now'),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: OutlinedButton(
//                           onPressed: () {},
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: AppColors.textPrimary,
//                             backgroundColor: AppColors.surface,
//                             side: const BorderSide(color: AppColors.stroke),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: Text(
//                             'Pay by invoice',
//                             style: AppTextStyles.button.copyWith(
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _row(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 96,
//             child: AppText(label, style: AppTextStyles.caption),
//           ),
//           Expanded(
//             child: AppText(
//               value,
//               style: AppTextStyles.bodyStrong,
//               size: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
