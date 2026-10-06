import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'sign_in_view.dart';
import '../controllers/ponto_controller.dart';
import '../models/punch_record.dart';
import '../models/workplace.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';
import 'cadastro_view.dart';
import 'detalhes_view.dart';
import '../widgets/punch_record_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.userName, required this.email, super.key});
  final String userName, email;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PontoController _controller = PontoController();
  final LocationService _locationService = LocationService();
  List<PunchRecord> _records = [];
  bool _loading = true, _punching = false;
  Position? _position;
  String? _locationError;
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  String get _nextType =>
      _records.isNotEmpty && _records.first.type == 'Entrada'
      ? 'Saída'
      : 'Entrada';
  Future<void> _loadRecords() async {
    try {
      _records = await _controller.list(widget.email);
    } catch (e) {
      if (mounted) {
        _toast('Não foi possível carregar os registros: $e');
      }
      _records = [];
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refreshLocation() async {
    setState(() {
      _punching = true;
      _locationError = null;
    });
    try {
      final p = await _locationService.currentPosition();
      if (mounted) setState(() => _position = p);
    } catch (e) {
      if (mounted) {
        setState(
          () => _locationError = e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _punching = false);
    }
  }

  Future<void> _registerPunch() async {
    final record = await Navigator.push<PunchRecord>(
      context,
      MaterialPageRoute(builder: (_) => CadastroView(accountId: widget.email)),
    );
    if (record != null && mounted) {
      _position = Position(
        latitude: record.latitude,
        longitude: record.longitude,
        timestamp: record.at,
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      await _loadRecords();
      if (mounted) _toast('${record.type} registrada com sucesso.');
    }
  }

  void _toast(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
  String get _greeting {
    final h = DateTime.now().hour;
    return h < 12
        ? 'Bom dia'
        : h < 18
        ? 'Boa tarde'
        : 'Boa noite';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Ponto Seguro',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          tooltip: 'Sair',
          onPressed: () async {
            await ApiService().logout();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (_) => false,
              );
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    ),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await _loadRecords();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              '$_greeting,',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),
            const SizedBox(height: 20),
            _locationCard(),
            const SizedBox(height: 16),
            _punchCard(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Registros recentes',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${_records.length} ${_records.length == 1 ? 'registro' : 'registros'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_records.isEmpty)
              _emptyState()
            else
              ..._records.map(
                (record) => PunchRecordCard(
                  record: record,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesView(registro: record),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  Widget _locationCard() {
    final distance = _position == null
        ? null
        : Geolocator.distanceBetween(
            _position!.latitude,
            _position!.longitude,
            workplace.latitude,
            workplace.longitude,
          );
    final inside = distance != null && distance <= radiusMeters;
    final color = inside ? const Color(0xFF176B58) : Colors.orange.shade800;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F1E9),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF176B58),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seu local de trabalho',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      workplace.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _punching ? null : _refreshLocation,
                tooltip: 'Atualizar localização',
                icon: const Icon(Icons.my_location),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            workplace.address,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                inside ? Icons.check_circle : Icons.info_outline,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  distance == null
                      ? 'Toque no botão para verificar sua localização'
                      : inside
                      ? 'Dentro da área · ${distance.round()} m do local'
                      : '${distance.round()} m do local · limite de 100 m',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              if (_punching)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          if (_locationError != null) ...[
            const SizedBox(height: 10),
            Text(
              _locationError!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _punchCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF176B58),
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Color(0xFF176B58), Color(0xFF104C40)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jornada de hoje',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 5),
        Text(
          _nextType == 'Entrada' ? 'Pronto para começar?' : 'Hora de encerrar?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _punching ? null : _registerPunch,
            icon: _punching
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF176B58),
                    ),
                  )
                : const Icon(Icons.touch_app),
            label: Text(_punching ? 'Verificando...' : 'Registrar $_nextType'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF176B58),
              minimumSize: const Size.fromHeight(52),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_outlined, color: Colors.white70, size: 14),
            SizedBox(width: 5),
            Text(
              'Localização validada em tempo real',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _emptyState() => Container(
    padding: const EdgeInsets.symmetric(vertical: 28),
    alignment: Alignment.center,
    child: Column(
      children: [
        Icon(Icons.event_note_outlined, size: 36, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          'Nenhum registro por enquanto',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}
