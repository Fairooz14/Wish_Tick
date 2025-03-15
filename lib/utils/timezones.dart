class TimeZone {
  final String country;
  final String timeZone;

  TimeZone({required this.country, required this.timeZone});

  static List<TimeZone> get availableTimeZones => [
        TimeZone(country: "UTC", timeZone: "UTC"), // Add UTC
        TimeZone(country: "United States", timeZone: "America/New_York"),
        TimeZone(country: "United Kingdom", timeZone: "Europe/London"),
        TimeZone(country: "India", timeZone: "Asia/Kolkata"),
        TimeZone(country: "Japan", timeZone: "Asia/Tokyo"),
        TimeZone(country: "Australia", timeZone: "Australia/Sydney"),
        TimeZone(country: "Bangladesh", timeZone: "Asia/Dhaka"),
        TimeZone(country: "Canada", timeZone: "America/Toronto"),
        TimeZone(country: "Finland", timeZone: "Europe/Helsinki"),
        TimeZone(country: "Brazil", timeZone: "America/Sao_Paulo"),
        TimeZone(country: "South Africa", timeZone: "Africa/Johannesburg"),
        TimeZone(country: "Russia", timeZone: "Europe/Moscow"),
        TimeZone(country: "China", timeZone: "Asia/Shanghai"),
      ];
}