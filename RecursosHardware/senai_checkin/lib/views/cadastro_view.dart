import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/registro_controller.dart';
import '../services/camera_service.dart';
import '../widgets/location_picker_sheet.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({
    super.key,
    this.controller,
    this.cameraService,
  });

  final RegistroController? controller;
  final CameraService? cameraService;

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  late final RegistroController _controller =
      widget.controller ?? RegistroController();
  late final CameraService _cameraService =
      widget.cameraService ?? CameraService();

  final TextEditingController _observacaoController = TextEditingController();
  bool _salvando = false;
  bool _capturandoFoto = false;
  String? _fotoPath;
  double? _latitudeSelecionada;
  double? _longitudeSelecionada;

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _tirarFoto() async {
    setState(() => _capturandoFoto = true);

    final caminhoFoto = await _cameraService.tirarFoto();

    if (!mounted) return;

    setState(() {
      _fotoPath = caminhoFoto;
      _capturandoFoto = false;
    });

    if (caminhoFoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissão de câmera negada ou captura cancelada.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
    }
  }

  Future<void> _abrirSeletorLocalizacao() async {
    final LatLng? pontoSelecionado = await showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPickerSheet(
        initialPosition: _latitudeSelecionada != null && _longitudeSelecionada != null
            ? LatLng(_latitudeSelecionada!, _longitudeSelecionada!)
            : const LatLng(-22.73917, -47.33139),
      ),
    );

    if (pontoSelecionado == null) {
      return;
    }

    setState(() {
      _latitudeSelecionada = pontoSelecionado.latitude;
      _longitudeSelecionada = pontoSelecionado.longitude;
    });
  }

  Future<void> _salvarRegistro() async {
    final observacao = _observacaoController.text.trim();

    if (observacao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha a observação antes de salvar.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
      return;
    }

    if (_fotoPath == null || _fotoPath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tire uma foto antes de salvar o registro.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final sucesso = await _controller.criarRegistro(
      observacao,
      caminhoFoto: _fotoPath!,
      latitude: _latitudeSelecionada,
      longitude: _longitudeSelecionada,
    );

    if (!mounted) return;

    setState(() => _salvando = false);

    if (sucesso) {
      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro salvo com sucesso!'),
          backgroundColor: Color(0xFF0284C7),
        ),
      );

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar o registro. Verifique as permissões e a localização.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Novo Registro',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFCC0000).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCC0000).withValues(alpha: 0.18)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: _capturandoFoto ? null : _tirarFoto,
                  child: _fotoPath == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 58,
                                color: Color(0xFFCC0000),
                              ),
                              SizedBox(height: 12),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  'Abrir câmera para tirar a foto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(
                                  File(_fotoPath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: TextButton.icon(
                                onPressed: _capturandoFoto ? null : _tirarFoto,
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Tirar outra foto'),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black.withValues(alpha: 0.55),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            if (_capturandoFoto)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.38),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        color: Color(0xFF0284C7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Localização do registro',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_latitudeSelecionada != null && _longitudeSelecionada != null)
                    Text(
                      'Lat: ${_latitudeSelecionada!.toStringAsFixed(6)}\nLng: ${_longitudeSelecionada!.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                        height: 1.5,
                      ),
                    )
                  else
                    const Text(
                      'Nenhuma localização escolhida. Use o mapa para definir o ponto.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _abrirSeletorLocalizacao,
                      icon: const Icon(Icons.map_rounded),
                      label: Text(
                        _latitudeSelecionada == null || _longitudeSelecionada == null
                            ? 'Selecionar no mapa'
                            : 'Alterar no mapa',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFCC0000),
                        side: const BorderSide(color: Color(0xFFCC0000)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Observação',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacaoController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Descreva a atividade realizada...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFCC0000),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFF0284C7),
                ),
                const SizedBox(width: 6),
                Text(
                  'A localização GPS será capturada automaticamente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: (_salvando || _fotoPath == null) ? null : _salvarRegistro,
                icon: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _salvando ? 'Salvando...' : 'Salvar Registro',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC0000),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF990000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
