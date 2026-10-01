import 'dart:io';

import 'package:flutter/material.dart';

import '../controllers/ponto_controller.dart';
import '../models/punch_record.dart';
import '../services/camera_service.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({required this.accountId, super.key});
  final String accountId;
  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _controller = PontoController();
  final _camera = CameraService();
  final _noteController = TextEditingController();
  bool _saving = false, _takingPhoto = false;
  String? _photoPath;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    setState(() => _takingPhoto = true);
    try {
      final path = await _camera.captureAndSave();
      if (mounted && path != null) setState(() => _photoPath = path);
    } catch (e) {
      if (mounted) _message('Não foi possível abrir a câmera: $e');
    } finally {
      if (mounted) setState(() => _takingPhoto = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final record = await _controller.register(
        widget.accountId,
        note: _noteController.text,
        photoPath: _photoPath ?? '',
      );
      if (!mounted) return;
      Navigator.pop<PunchRecord>(context, record);
    } catch (e) {
      if (mounted) _message(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Novo registro',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F1E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF176B58)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'A localização será conferida antes de salvar. O ponto só é aceito dentro de 100 m.',
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Observação',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            decoration: const InputDecoration(
              hintText: 'Ex.: início do expediente, atividade realizada...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Comprovante fotográfico (opcional)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _takingPhoto ? null : _takePhoto,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              clipBehavior: Clip.antiAlias,
              child: _photoPath != null
                  ? Image.file(File(_photoPath!), fit: BoxFit.cover)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _takingPhoto
                              ? const CircularProgressIndicator()
                              : const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 38,
                                  color: Color(0xFF176B58),
                                ),
                          const SizedBox(height: 10),
                          Text(
                            _takingPhoto
                                ? 'Abrindo câmera...'
                                : 'Toque para tirar uma foto',
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.fingerprint),
            label: Text(
              _saving ? 'Validando localização...' : 'Confirmar ponto',
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
          ),
        ],
      ),
    ),
  );
}
