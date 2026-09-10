class EventItem {
  const EventItem({
    required this.id,
    required this.name,
    required this.region,
    required this.flatRegion,
    required this.startDate,
    required this.endDate,
    required this.markup,
    this.allRegions = false,
    this.allFlatRegions = false,
    this.blackout = false,
  });

  final String id;
  final String name;
  final String region;
  final String flatRegion;
  final DateTime startDate;
  final DateTime endDate;
  final String markup;
  final bool allRegions;
  final bool allFlatRegions;
  final bool blackout;

  String get locationLabel {
    if (allRegions) return 'All Regions';
    if (allFlatRegions) return '$region (All Flat Regions)';
    return '$region ($flatRegion)';
  }

  EventItem copyWith({
    String? id,
    String? name,
    String? region,
    String? flatRegion,
    DateTime? startDate,
    DateTime? endDate,
    String? markup,
    bool? allRegions,
    bool? allFlatRegions,
    bool? blackout,
  }) {
    return EventItem(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      flatRegion: flatRegion ?? this.flatRegion,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      markup: markup ?? this.markup,
      allRegions: allRegions ?? this.allRegions,
      allFlatRegions: allFlatRegions ?? this.allFlatRegions,
      blackout: blackout ?? this.blackout,
    );
  }
}
