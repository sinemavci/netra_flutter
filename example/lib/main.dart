import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:netra_flutter/common/exceptions/base_platform_exception.dart';
import 'package:netra_flutter/common/models/cache_options.dart';
import 'package:netra_flutter/common/observers/cache_event.dart';
import 'package:netra_flutter/common/observers/queue_event.dart';
import 'package:netra_flutter/common/observers/request_event.dart';
import 'dart:async';
import 'package:netra_flutter/netra_flutter_plugin.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netra Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const NetraExamplePage(),
    );
  }
}

// ── Result model ────────────────────────────────────────────────────────────

class RequestResult {
  final String label;
  final int? statusCode;
  final String? data;
  final String? error;

  RequestResult({
    required this.label,
    this.statusCode,
    this.data,
    this.error,
  });

  bool get isSuccess => error == null;
}

// ── Page ────────────────────────────────────────────────────────────────────

class NetraExamplePage extends StatefulWidget {
  const NetraExamplePage({super.key});

  @override
  State<NetraExamplePage> createState() => _NetraExamplePageState();
}

class _NetraExamplePageState extends State<NetraExamplePage> {
  // ── clients ──────────────────────────────────────────────────────────────

  late final NetraClient _mainClient;
  late final NetraClient _jsonPlaceholderClient;

  // ── state ─────────────────────────────────────────────────────────────────

  RequestResult? _lastResult;
  Uint8List? _imageBytes;
  bool _loading = false;
  StreamController<Uint8List>? _imageStreamController;

  final ImagePicker _picker = ImagePicker();

  // ── lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _mainClient = NetraClient(
      baseUrl: 'http://10.0.2.2:3001',
      headers: {'Authorization': 'Bearer token'},
      converterType: ConverterType.gson,
    );

    _jsonPlaceholderClient = NetraClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      converterType: ConverterType.kotlinX,
    );

    _registerObservers();
  }

  @override
  void dispose() {
    _imageStreamController?.close();
    super.dispose();
  }

  // ── observers ─────────────────────────────────────────────────────────────

  void _registerObservers() {
    _mainClient.on(RequestEvent.requestExecuted((request) {
      _showSnackbar('⚡ Executing: ${request.url}', color: Colors.blueGrey);
    }));

    _mainClient.on(RequestEvent.requestSuccess((request, response) {
      _showSnackbar('✅ Success: ${response.statusCode}', color: Colors.green);
    }));

    _mainClient.on(RequestEvent.requestFailed((request, response) {
      _showSnackbar('❌ Failed: ${response?.statusCode ?? 'unknown'}', color: Colors.red);
    }));

    _mainClient.on(CacheEvent.cacheHit((request, ageMs, ttlMs) {
      _showSnackbar('💾 Cache hit (age: ${ageMs}ms)', color: Colors.teal);
    }));

    _mainClient.on(CacheEvent.cacheMiss((request) {
      _showSnackbar('🔍 Cache miss: ${request.url}', color: Colors.orange);
    }));

    _mainClient.on(CacheEvent.cacheStored((request, ageMs, ttlMs) {
      _showSnackbar('📦 Cache stored', color: Colors.teal);
    }));

    _mainClient.on(CacheEvent.cacheExpired((request, ageMs, ttlMs, expiredByMs) {
      _showSnackbar('⏰ Cache expired (by: ${expiredByMs}ms)', color: Colors.orange);
    }));

    _mainClient.on(CacheEvent.cacheStaleUsed((request, ageMs, ttlMs, expiredByMs) {
      _showSnackbar('♻️ Stale cache used', color: Colors.amber);
    }));

    _mainClient.on(QueueEvent.requestQueued((url, queueOrder, createdAt) {
      _showSnackbar('📬 Queued: $url (order: $queueOrder)', color: Colors.purple);
    }));

    _mainClient.on(QueueEvent.queuedRequestRestored((url) {
      _showSnackbar('🔄 Queue restored: $url', color: Colors.indigo);
    }));

    _mainClient.on(QueueEvent.queuedRequestExecuted((url, response) {
      _showSnackbar('✅ Queue executed: ${response.statusCode}', color: Colors.green);
    }));

    _mainClient.on(QueueEvent.queuedRequestFailed((url, response) {
      _showSnackbar('❌ Queue failed: $url ${response?.statusCode != null ? 'status code: ${response?.statusCode}' : ''}', color: Colors.red);
    }));
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  void _showSnackbar(String message, {Color color = Colors.black87}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 13)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _setResult(RequestResult result) {
    if (!mounted) return;
    setState(() => _lastResult = result);
  }

  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => _loading = value);
  }

  // ── request handlers ──────────────────────────────────────────────────────

  Future<void> _handleGet() async {
    _setLoading(true);
    try {
      final result = await _mainClient.get(
        requestOptions: RequestOptions(
          url: '/?status=200&delay=1000',
          offlinePolicyAction: OfflinePolicyAction.queue,
          cancelOnDispose: true,
          cacheOptions: CacheOptions(),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.timeout(
            timeout: const Duration(seconds: 5),
          ),
        ),
      );
      _setResult(RequestResult(
        label: 'GET /?status=200',
        statusCode: result?.statusCode,
        data: jsonEncode(result?.data),
      ));
    } on NetraNetworkException catch (e) {
      _setResult(RequestResult(label: 'GET /?status=200', error: e.message));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handlePost() async {
    _setLoading(true);
    try {
      final result = await _jsonPlaceholderClient.post(
        requestOptions: RequestOptions(
          url: '/users',
          body: RequestBody.createJson(
            jsonEncode({'name': 'Sinem', 'job': 'developer'}),
          ),
          offlinePolicyAction: OfflinePolicyAction.retry(
            retries: 3,
            retryInterval: const Duration(seconds: 4),
          ),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(
            delay: const Duration(seconds: 2),
          ),
        ),
      );
      _setResult(RequestResult(
        label: 'POST /users',
        statusCode: result?.statusCode,
        data: jsonEncode(result?.data),
      ));
    } on NetraNetworkException catch (e) {
      _setResult(RequestResult(label: 'POST /users', error: e.message));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handlePut() async {
    _setLoading(true);
    try {
      final result = await _jsonPlaceholderClient.put(
        requestOptions: RequestOptions(
          url: '/users/1',
          body: RequestBody.createBytes(
            Uint8List.fromList(
              utf8.encode(jsonEncode({'name': 'Sinem', 'job': 'mobile developer'})),
            ),
          ),
          offlinePolicyAction: OfflinePolicyAction.retry(
            retries: 3,
            retryInterval: const Duration(seconds: 4),
          ),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(
            delay: const Duration(seconds: 2),
          ),
        ),
      );
      _setResult(RequestResult(
        label: 'PUT /users/1',
        statusCode: result?.statusCode,
        data: jsonEncode(result?.data),
      ));
    } on NetraNetworkException catch (e) {
      _setResult(RequestResult(label: 'PUT /users/1', error: e.message));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleDelete() async {
    _setLoading(true);
    try {
      final result = await _jsonPlaceholderClient.delete(
        requestOptions: RequestOptions(
          url: '/users/1',
          offlinePolicyAction: OfflinePolicyAction.retry(
            retries: 3,
            retryInterval: const Duration(seconds: 4),
          ),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(
            delay: const Duration(seconds: 2),
          ),
          headers: {'X-Custom': 'netra-example'},
        ),
      );
      _setResult(RequestResult(
        label: 'DELETE /users/1',
        statusCode: result?.statusCode,
        data: jsonEncode(result?.data),
      ));
    } on NetraNetworkException catch (e) {
      _setResult(RequestResult(label: 'DELETE /users/1', error: e.message));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleGetImage() async {
    _setLoading(true);
    setState(() => _imageBytes = null);

    _imageStreamController?.close();
    _imageStreamController = StreamController<Uint8List>();

    try {
      final stream = await _mainClient.getStream(
        requestOptions: RequestOptions(
          url: '/image',
          cancelOnDispose: true,
          offlinePolicyAction: OfflinePolicyAction.queue,
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(
            delay: const Duration(seconds: 2),
          ),
        ),
      );

      final List<int> buffer = [];

      stream.listen(
            (data) => buffer.addAll(data),
        onDone: () {
          final bytes = Uint8List.fromList(buffer);
          if (mounted) setState(() => _imageBytes = bytes);
          _setResult(RequestResult(
            label: 'GET /image (stream)',
            statusCode: 200,
            data: '${bytes.length} bytes received',
          ));
          _setLoading(false);
        },
        onError: (e) {
          _setResult(RequestResult(
            label: 'GET /image (stream)',
            error: e.toString(),
          ));
          _setLoading(false);
        },
      );
    } on NetraNetworkException catch (e) {
      _setResult(RequestResult(label: 'GET /image (stream)', error: e.message));
      _setLoading(false);
    }
  }

  Future<void> _handlePostImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;

    _setLoading(true);
    try {
      final bytes = await file.readAsBytes();
      final result = await _mainClient.post(
        requestOptions: RequestOptions(
          url: '/upload',
          body: RequestBody.multipart([
            RequestBodyPart.file(
              name: 'image',
              fileName: file.name,
              bytes: bytes,
              contentType: 'image/jpeg',
            ),
          ]),
          offlinePolicyAction: OfflinePolicyAction.retry(
            retries: 3,
            retryInterval: const Duration(seconds: 4),
          ),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(
            delay: const Duration(seconds: 2),
          ),
        ),
      );
      _setResult(RequestResult(
        label: 'POST /upload',
        statusCode: result?.statusCode,
        data: jsonEncode(result?.data),
      ));
    } on NetraNetworkException catch (e) {
      _setResult(RequestResult(label: 'POST /upload', error: e.message));
    } finally {
      _setLoading(false);
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Netra SDK Example'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // ── buttons ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _ActionButton(label: 'GET', onTap: _handleGet, loading: _loading),
                _ActionButton(label: 'POST', onTap: _handlePost, loading: _loading),
                _ActionButton(label: 'PUT', onTap: _handlePut, loading: _loading),
                _ActionButton(label: 'DELETE', onTap: _handleDelete, loading: _loading),
                _ActionButton(label: 'GET Image', onTap: _handleGetImage, loading: _loading),
                _ActionButton(label: 'POST Image', onTap: _handlePostImage, loading: _loading),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── result card ────────────────────────────────────────────────
          if (_lastResult != null)
            _ResultCard(result: _lastResult!),

          // ── image preview ──────────────────────────────────────────────
          if (_imageBytes != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),

          if (_loading && _imageBytes == null)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: loading ? null : onTap,
      child: Text(label),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final RequestResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.isSuccess ? Colors.green : Colors.red;
    final bgColor = result.isSuccess
        ? Colors.green.withOpacity(0.05)
        : Colors.red.withOpacity(0.05);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label + cache badge
          Row(
            children: [
              Expanded(
                child: Text(
                  result.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // status code
          if (result.statusCode != null)
            _ResultRow(
              label: 'Status',
              value: result.statusCode.toString(),
              valueColor: color,
            ),

          // data
          if (result.data != null)
            _ResultRow(label: 'Data', value: result.data!),

          // error
          if (result.error != null)
            _ResultRow(
              label: 'Error',
              value: result.error!,
              valueColor: Colors.red,
            ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ResultRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: valueColor ?? Colors.grey[800],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}