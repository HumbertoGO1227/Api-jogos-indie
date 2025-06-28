import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/jogo.dart';
import '../services/jogo_service.dart';

class JogoFormScreen extends StatefulWidget {
  final Jogo? jogo;

  const JogoFormScreen({super.key, this.jogo});

  @override
  State<JogoFormScreen> createState() => _JogoFormScreenState();
}

class _JogoFormScreenState extends State<JogoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _generoController;
  late TextEditingController _plataformaController;
  late TextEditingController _avaliacaoController;
  late TextEditingController _descricaoController;
  late TextEditingController _urlImagemController;

  bool _isLoading = false;
  bool _showImagePreview = false;

  final List<String> _generos = [
    'Ação',
    'Aventura',
    'RPG',
    'Estratégia',
    'Puzzle',
    'Plataforma',
    'Corrida',
    'Esportes',
    'Simulação',
    'Terror',
    'Indie',
    'Casual',
  ];

  final List<String> _plataformas = [
    'PC',
    'PlayStation',
    'Xbox',
    'Nintendo Switch',
    'Mobile',
    'Steam',
    'Epic Games',
    'Multiplataforma',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.jogo?.nome ?? '');
    _generoController = TextEditingController(text: widget.jogo?.genero ?? '');
    _plataformaController = TextEditingController(
      text: widget.jogo?.plataforma ?? '',
    );
    _avaliacaoController = TextEditingController(
      text: widget.jogo?.avaliacao.toString() ?? '',
    );
    _descricaoController = TextEditingController(
      text: widget.jogo?.descricao ?? '',
    );
    _urlImagemController = TextEditingController(
      text: widget.jogo?.urlImagem ?? '',
    );

    if (_urlImagemController.text.isNotEmpty) {
      _showImagePreview = true;
    }

    _urlImagemController.addListener(() {
      setState(() {
        _showImagePreview = _urlImagemController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _generoController.dispose();
    _plataformaController.dispose();
    _avaliacaoController.dispose();
    _descricaoController.dispose();
    _urlImagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.jogo != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Jogo' : 'Novo Jogo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showImagePreview) _buildImagePreview(),

                    _buildSectionCard(
                      'Informações Básicas',
                      Icons.info_outline,
                      Colors.blue,
                      [
                        _buildTextField(
                          controller: _nomeController,
                          label: 'Nome do Jogo',
                          icon: Icons.videogame_asset,
                          validator: (value) =>
                              value!.isEmpty ? 'Nome é obrigatório' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          controller: _generoController,
                          label: 'Gênero',
                          icon: Icons.category,
                          options: _generos,
                          validator: (value) =>
                              value!.isEmpty ? 'Gênero é obrigatório' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          controller: _plataformaController,
                          label: 'Plataforma',
                          icon: Icons.devices,
                          options: _plataformas,
                          validator: (value) => value!.isEmpty
                              ? 'Plataforma é obrigatória'
                              : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionCard(
                      'Avaliação',
                      Icons.star_outline,
                      Colors.amber,
                      [_buildRatingField()],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionCard(
                      'Descrição',
                      Icons.description_outlined,
                      Colors.green,
                      [
                        _buildTextField(
                          controller: _descricaoController,
                          label: 'Descrição do Jogo',
                          icon: Icons.notes,
                          maxLines: 4,
                          validator: (value) =>
                              value!.isEmpty ? 'Descrição é obrigatória' : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionCard(
                      'Imagem',
                      Icons.image_outlined,
                      Colors.purple,
                      [
                        _buildTextField(
                          controller: _urlImagemController,
                          label: 'URL da Imagem',
                          icon: Icons.link,
                          validator: (value) => value!.isEmpty
                              ? 'URL da imagem é obrigatória'
                              : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveJogo,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(isEditing ? Icons.update : Icons.save),
                    label: Text(
                      _isLoading
                          ? (isEditing ? 'Atualizando...' : 'Salvando...')
                          : (isEditing ? 'Atualizar Jogo' : 'Salvar Jogo'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.preview, color: Colors.purple[600]),
                  const SizedBox(width: 8),
                  const Text(
                    'Imagemdo Jogo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: Image.network(
                    _urlImagemController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text('Erro ao carregar imagem'),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
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
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> options,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: options.contains(controller.text) ? controller.text : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
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
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(value: option, child: Text(option));
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.text = newValue;
        }
      },
      validator: validator,
      isExpanded: true,
    );
  }

  Widget _buildRatingField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _avaliacaoController,
          label: 'Nota (0.0 - 10.0)',
          icon: Icons.star,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value!.isEmpty) return 'Avaliação é obrigatória';
            final rating = double.tryParse(value);
            if (rating == null) return 'Digite um número válido';
            if (rating < 0 || rating > 10) return 'Nota deve ser de 0 a 10';
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Digite uma nota de 0.0 a 10.0',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Future<void> _saveJogo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final jogo = Jogo(
        id: widget.jogo?.id ?? 0,
        nome: _nomeController.text.trim(),
        genero: _generoController.text.trim(),
        plataforma: _plataformaController.text.trim(),
        avaliacao: double.parse(_avaliacaoController.text),
        descricao: _descricaoController.text.trim(),
        urlImagem: _urlImagemController.text.trim(),
      );

      if (widget.jogo != null) {
        await JogoService.atualizarJogo(jogo);
      } else {
        await JogoService.adicionarJogo(jogo);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.jogo != null
                  ? 'Jogo atualizado com sucesso!'
                  : 'Jogo adicionado com sucesso!',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar o jogo: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
