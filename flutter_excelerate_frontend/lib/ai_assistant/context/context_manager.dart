import '../models/ai_context.dart';
import 'ai_context_provider.dart';

class ContextManager {
  final _ContextCache _cache;
  final String _baseSystemPrompt;

  AiApplicationContext _applicationContext;

  ContextManager({
    required String baseSystemPrompt,
    AiApplicationContext? initialContext,
  })  : _baseSystemPrompt = baseSystemPrompt,
        _cache = _ContextCache(),
        _applicationContext = initialContext ?? const AiApplicationContext();

  AiApplicationContext get currentContext => _applicationContext;
  String get baseSystemPrompt => _baseSystemPrompt;

  void updateContext(AiApplicationContext newContext) {
    _applicationContext = _applicationContext.copyWith(
      userContext: newContext.userContext,
      profileContext: newContext.profileContext,
      dashboardContext: newContext.dashboardContext,
      programsContext: newContext.programsContext,
      assignmentsContext: newContext.assignmentsContext,
      messagesContext: newContext.messagesContext,
      notificationsContext: newContext.notificationsContext,
      dailyPulseContext: newContext.dailyPulseContext,
      currentScreenContext: newContext.currentScreenContext,
      navigationContext: newContext.navigationContext,
      sessionContext: newContext.sessionContext,
      conversationContext: newContext.conversationContext,
    );
    _cache.clear();
  }

  void resetContext() {
    _applicationContext = const AiApplicationContext();
    _cache.clear();
  }

  AiContext buildContext({
    required String cacheKey,
    required List<Map<String, dynamic>> rawDocuments,
    Map<String, dynamic>? extraMetadata,
    String? overrideSystemPrompt,
    bool forceRefresh = false,
  }) {
    if (!forceRefresh) {
      final cached = _cache.get(cacheKey);
      if (cached != null) return cached;
    }

    final collector = _ContextCollector();
    for (final doc in rawDocuments) {
      collector.addRawDocument(doc);
    }

    final combinedMetadata = <String, dynamic>{};
    
    final appMetadata = _applicationContext.toMap();
    if (appMetadata.isNotEmpty) {
      combinedMetadata['appContext'] = appMetadata;
    }

    if (extraMetadata != null) {
      combinedMetadata.addAll(extraMetadata);
    }

    combinedMetadata.forEach(collector.addMetadata);

    final context = AiContext(
      systemPrompt: overrideSystemPrompt ?? _baseSystemPrompt,
      documents: collector.documents,
      extraContext: collector.extraContext,
    );

    _cache.set(cacheKey, context);
    return context;
  }

  void clearCache() => _cache.clear();
}

class _ContextCache {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultExpiration = const Duration(minutes: 15);

  void set(String key, AiContext context) {
    _cache[key] = _CacheEntry(
      context: context,
      expiresAt: DateTime.now().add(defaultExpiration),
    );
  }

  AiContext? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(key);
      return null;
    }
    return entry.context;
  }

  void clear() => _cache.clear();
}

class _CacheEntry {
  final AiContext context;
  final DateTime expiresAt;

  const _CacheEntry({
    required this.context,
    required this.expiresAt,
  });
}

class _ContextCollector {
  final List<String> _documents = [];
  final Map<String, dynamic> _extraContext = {};
  static const _excludedKeys = {'password', 'token', 'secret', 'hash', 'private', 'auth', 'email', 'phone', 'ssn', 'credit', 'card', 'address'};

  void addRawDocument(Map<String, dynamic> rawData) {
    final filtered = _filter(rawData);
    final formatted = _formatDocument(filtered);
    if (formatted.isNotEmpty) {
      _documents.add(formatted);
    }
  }

  void addMetadata(String key, dynamic value) {
    if (value != null) {
      _extraContext[key] = value;
    }
  }

  List<String> get documents => List.unmodifiable(_documents);
  Map<String, dynamic> get extraContext => Map.unmodifiable(_extraContext);

  static Map<String, dynamic> _filter(Map<String, dynamic> rawData) {
    final filtered = <String, dynamic>{};
    for (final entry in rawData.entries) {
      if (_shouldKeep(entry.key, entry.value)) {
        if (entry.value is Map<String, dynamic>) {
          filtered[entry.key] = _filter(entry.value as Map<String, dynamic>);
        } else if (entry.value is List) {
          filtered[entry.key] = _filterList(entry.value as List);
        } else {
          filtered[entry.key] = entry.value;
        }
      }
    }
    return filtered;
  }

  static bool _shouldKeep(String key, dynamic value) {
    if (value == null) return false;
    final lowerKey = key.toLowerCase();
    for (final excluded in _excludedKeys) {
      if (lowerKey.contains(excluded)) return false;
    }
    return true;
  }

  static List<dynamic> _filterList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return _filter(item);
      }
      return item;
    }).toList();
  }

  static String _formatDocument(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    _formatNode(data, buffer, 0);
    return buffer.toString().trim();
  }

  static void _formatNode(Map<String, dynamic> node, StringBuffer buffer, int indentLevel) {
    final indent = '  ' * indentLevel;
    for (final entry in node.entries) {
      if (entry.value is Map<String, dynamic>) {
        buffer.writeln('$indent- ${entry.key}:');
        _formatNode(entry.value as Map<String, dynamic>, buffer, indentLevel + 1);
      } else if (entry.value is List) {
        buffer.writeln('$indent- ${entry.key}:');
        for (final item in (entry.value as List)) {
          if (item is Map<String, dynamic>) {
            _formatNode(item, buffer, indentLevel + 2);
          } else {
            buffer.writeln('$indent    - $item');
          }
        }
      } else {
        buffer.writeln('$indent- ${entry.key}: ${entry.value}');
      }
    }
  }
}

