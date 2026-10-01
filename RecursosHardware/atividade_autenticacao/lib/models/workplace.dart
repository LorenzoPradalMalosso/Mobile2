class Workplace {
  const Workplace({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
  final String name;
  final String address;
  final double latitude;
  final double longitude;
}

const workplace = Workplace(
  name: 'Escritório central',
  address: 'Av. Paulista, 1000 · São Paulo',
  latitude: -23.5631,
  longitude: -46.6544,
);
const radiusMeters = 100.0;
