import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fasta_deliveries_store/api/api_client.dart';
import 'package:fasta_deliveries_store/helper/route_helper.dart';

class BuyCarSellerScreen extends StatefulWidget {
  final String section;

  const BuyCarSellerScreen({super.key, required this.section});

  @override
  State<BuyCarSellerScreen> createState() => _BuyCarSellerScreenState();
}

class _BuyCarSellerScreenState extends State<BuyCarSellerScreen> {
  final ApiClient _api = Get.find<ApiClient>();
  List<Map<String, dynamic>> _cars = [];
  Map<String, dynamic> _limits = {};
  int _page = 1;
  bool _hasMore = false;
  bool _loadingMore = false;
  String _searchQuery = '';
  String _saleFilter = 'all';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.section == 'cars' || widget.section == 'overview') {
      _loadCars();
      _loadLimits();
    } else if (widget.section == 'plans') {
      _loadLimits();
    } else {
      _loading = false;
    }
  }

  Map<String, dynamic> _content(Response response) {
    final dynamic body = response.body;
    if (body is Map && body['content'] is Map) {
      return Map<String, dynamic>.from(body['content'] as Map);
    }
    return {};
  }

  List<Map<String, dynamic>> _rows(Response response) {
    final content = _content(response);
    final dynamic data = content['data'];
    return data is List
        ? data.whereType<Map>().map(Map<String, dynamic>.from).toList()
        : [];
  }

  Future<void> _loadCars({bool append = false}) async {
    final page = append ? _page + 1 : 1;
    setState(() {
      _loading = !append;
      _loadingMore = append;
      _error = null;
    });
    final query = <String, String>{
      'limit': '30',
      'offset': '$page',
      if (_searchQuery.trim().isNotEmpty) 'search': _searchQuery.trim(),
      if (_saleFilter != 'all') 'sale_status': _saleFilter,
    };
    final response = await _api.getData(
      '/api/v1/buycar/vendor/vehicle/list?${Uri(queryParameters: query).query}',
      handleError: false,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _loadingMore = false;
      if (response.isOk) {
        final rows = _rows(response);
        _cars = append ? [..._cars, ...rows] : rows;
        _page = page;
        final pagination = _content(response)['pagination'];
        final total = pagination is Map
            ? int.tryParse('${pagination['total_size']}')
            : null;
        _hasMore = total != null ? _cars.length < total : rows.length == 30;
        final content = _content(response);
        if (content['subscription'] is Map) {
          _limits = {
            ..._limits,
            ...Map<String, dynamic>.from(content['subscription'] as Map),
          };
        }
      } else {
        _error = response.statusText ?? 'Unable to load your listings.';
      }
    });
  }

  Future<void> _loadLimits() async {
    final response = await _api.getData(
      '/api/v1/buycar/vendor/vehicle/limits',
      handleError: false,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (response.isOk) {
        _limits = _content(response);
      } else {
        _error = response.statusText ?? 'Unable to load subscription details.';
      }
    });
  }

  Future<void> _update(String path, Map<String, dynamic> body) async {
    final response = await _api.putData(path, body, handleError: false);
    if (!mounted) return;
    _message(
      response.isOk
          ? 'Updated successfully.'
          : response.statusText ?? 'Unable to update this request.',
    );
    if (response.isOk) _loadCars();
  }

  Future<void> _openNewListing() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _NewCarListingDialog(),
    );
    if (created == true) {
      _loadCars();
      _loadLimits();
    }
  }

  Future<void> _openEditListing(Map<String, dynamic> car) async {
    final response = await _api.getData(
      '/api/v1/buycar/vendor/vehicle/details/${car['id']}',
      handleError: false,
    );
    if (!mounted) return;
    if (!response.isOk) {
      _message(response.statusText ?? 'Unable to load listing details.');
      return;
    }
    final details = _content(response);
    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _NewCarListingDialog(vehicleId: car['id'], initial: details),
    );
    if (updated == true) _loadCars();
  }

  Future<void> _toggleListing(dynamic id) async {
    final response = await _api.getData(
      '/api/v1/buycar/vendor/vehicle/status/$id',
      handleError: false,
    );
    if (!mounted) return;
    _message(
      response.isOk
          ? 'Listing visibility updated.'
          : response.statusText ?? 'Unable to update listing visibility.',
    );
    if (response.isOk) _loadCars();
  }

  void _message(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.section) {
      'activity' => 'Buyer activity',
      'cars' => 'My car listings',
      'plans' => 'Listing subscription',
      _ => 'BuyCar seller centre',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _error != null
          ? _LoadError(
              message: _error!,
              onRetry: () async {
                if (widget.section == 'plans') {
                  await _loadLimits();
                } else {
                  await _loadCars();
                }
              },
            )
          : switch (widget.section) {
              'activity' => const _BuyerActivity(),
              'cars' =>
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _CarsList(
                        cars: _cars,
                        limits: _limits,
                        onRefresh: _loadCars,
                        onCreate: _openNewListing,
                        canList: _limits['can_list'] != false,
                        onManage: () =>
                            Get.toNamed(RouteHelper.getMySubscriptionRoute()),
                        hasMore: _hasMore,
                        loadingMore: _loadingMore,
                        onLoadMore: () => _loadCars(append: true),
                        onFilter: (filter) {
                          setState(() => _saleFilter = filter);
                          _loadCars();
                        },
                        saleFilter: _saleFilter,
                        onSearch: (query) {
                          setState(() => _searchQuery = query);
                          _loadCars();
                        },
                        onEdit: _openEditListing,
                        onToggle: _toggleListing,
                        onStatus: (id, status) => _update(
                          '/api/v1/buycar/vendor/vehicle/sale-status/$id',
                          {'sale_status': status},
                        ),
                        onDelete: (id) async {
                          final response = await _api.deleteData(
                            '/api/v1/buycar/vendor/vehicle/delete/$id',
                            handleError: false,
                          );
                          if (!mounted) return;
                          _message(
                            response.isOk
                                ? 'Listing deleted.'
                                : response.statusText ??
                                      'Unable to delete listing.',
                          );
                          if (response.isOk) _loadCars();
                        },
                      ),
              'plans' =>
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _SubscriptionDetails(
                        limits: _limits,
                        onManage: () =>
                            Get.toNamed(RouteHelper.getMySubscriptionRoute()),
                      ),
              _ => _Overview(
                limits: _limits,
                cars: _cars,
                onRefresh: _loadCars,
                onCreate: _openNewListing,
                onManage: () =>
                    Get.toNamed(RouteHelper.getMySubscriptionRoute()),
              ),
            },
    );
  }
}

class _Overview extends StatelessWidget {
  final Map<String, dynamic> limits;
  final List<Map<String, dynamic>> cars;
  final Future<void> Function() onRefresh;
  final VoidCallback onCreate;
  final VoidCallback onManage;

  const _Overview({
    required this.limits,
    required this.cars,
    required this.onRefresh,
    required this.onCreate,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SubscriptionCard(limits: limits),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: limits['can_list'] == false ? onManage : onCreate,
            icon: const Icon(Icons.add),
            label: Text(
              limits['can_list'] == false
                  ? 'View subscription plans'
                  : 'List a vehicle',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recent listings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (cars.isEmpty)
            const Text('No vehicles listed yet.')
          else
            ...cars.take(5).map((car) => _CarTile(car: car)),
          const SizedBox(height: 20),
          const Text(
            'BuyCar sellers pay for listing subscriptions only. Vehicle sale payments are arranged directly between the buyer and seller; seller earnings and wallet features are not used.',
          ),
        ],
      ),
    );
  }
}

class _CarsList extends StatelessWidget {
  final List<Map<String, dynamic>> cars;
  final Map<String, dynamic> limits;
  final Future<void> Function() onRefresh;
  final VoidCallback onCreate;
  final bool hasMore;
  final bool loadingMore;
  final Future<void> Function() onLoadMore;
  final bool canList;
  final VoidCallback onManage;
  final void Function(String) onFilter;
  final void Function(String) onSearch;
  final String saleFilter;
  final Future<void> Function(Map<String, dynamic>) onEdit;
  final Future<void> Function(dynamic) onToggle;
  final void Function(dynamic id, String status) onStatus;
  final Future<void> Function(dynamic id) onDelete;

  const _CarsList({
    required this.cars,
    required this.limits,
    required this.onRefresh,
    required this.onCreate,
    required this.hasMore,
    required this.loadingMore,
    required this.onLoadMore,
    required this.canList,
    required this.onManage,
    required this.onFilter,
    required this.onSearch,
    required this.saleFilter,
    required this.onEdit,
    required this.onToggle,
    required this.onStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SubscriptionCard(limits: limits),
          const SizedBox(height: 12),
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
            decoration: const InputDecoration(
              labelText: 'Search your listings',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: saleFilter,
            decoration: const InputDecoration(labelText: 'Sale status'),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All listings')),
              DropdownMenuItem(value: 'available', child: Text('Available')),
              DropdownMenuItem(value: 'reserved', child: Text('Reserved')),
              DropdownMenuItem(value: 'sold', child: Text('Sold')),
              DropdownMenuItem(value: 'withdrawn', child: Text('Withdrawn')),
            ],
            onChanged: (value) => onFilter(value ?? 'all'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: canList ? onCreate : onManage,
            icon: const Icon(Icons.add),
            label: Text(canList ? 'List a vehicle' : 'View subscription plans'),
          ),
          const SizedBox(height: 12),
          if (cars.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No vehicle listings yet.')),
            ),
          ...cars.map(
            (car) => _CarTile(
              car: car,
              onEdit: onEdit,
              onToggle: onToggle,
              onStatus: onStatus,
              onDelete: onDelete,
            ),
          ),
          if (hasMore)
            OutlinedButton(
              onPressed: loadingMore ? null : onLoadMore,
              child: loadingMore
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Load more listings'),
            ),
        ],
      ),
    );
  }
}

class _CarTile extends StatelessWidget {
  final Map<String, dynamic> car;
  final Future<void> Function(Map<String, dynamic>)? onEdit;
  final Future<void> Function(dynamic)? onToggle;
  final void Function(dynamic id, String status)? onStatus;
  final Future<void> Function(dynamic id)? onDelete;

  const _CarTile({
    required this.car,
    this.onEdit,
    this.onToggle,
    this.onStatus,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final status = car['sale_status']?.toString() ?? 'available';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car['name']?.toString() ?? 'Vehicle',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'KES ${car['sale_price'] ?? ''}  •  ${car['model_year'] ?? ''}  •  $status',
            ),
            if (car['open_offers_count'] != null)
              Text(
                '${car['open_offers_count']} open offers  •  ${car['open_viewings_count'] ?? 0} viewings  •  ${car['unanswered_questions_count'] ?? 0} questions',
              ),
            if (onStatus != null ||
                onDelete != null ||
                onEdit != null ||
                onToggle != null)
              Wrap(
                spacing: 8,
                children: [
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: () => onEdit!(car),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                  if (onToggle != null)
                    TextButton(
                      onPressed: () => onToggle!(car['id']),
                      child: Text(
                        car['status'] == true ? 'Hide listing' : 'Show listing',
                      ),
                    ),
                  if (onStatus != null && status == 'available')
                    TextButton(
                      onPressed: () => onStatus!(car['id'], 'sold'),
                      child: const Text('Mark sold'),
                    ),
                  if (onStatus != null && status == 'available')
                    TextButton(
                      onPressed: () => onStatus!(car['id'], 'reserved'),
                      child: const Text('Mark reserved'),
                    ),
                  if (onStatus != null && status == 'reserved')
                    TextButton(
                      onPressed: () => onStatus!(car['id'], 'available'),
                      child: const Text('Mark available'),
                    ),
                  if (onStatus != null &&
                      (status == 'sold' || status == 'withdrawn'))
                    TextButton(
                      onPressed: () => onStatus!(car['id'], 'available'),
                      child: const Text('Relist'),
                    ),
                  if (onStatus != null && status == 'available')
                    TextButton(
                      onPressed: () => onStatus!(car['id'], 'withdrawn'),
                      child: const Text('Withdraw'),
                    ),
                  if (onDelete != null)
                    TextButton(
                      onPressed: () => onDelete!(car['id']),
                      child: const Text('Delete'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> limits;

  const _SubscriptionCard({required this.limits});

  @override
  Widget build(BuildContext context) {
    final used = limits['listings_in_use'] ?? '—';
    final limit = limits['listing_limit'] ?? '—';
    final plan = limits['plan'] ?? 'Subscription required';
    final allowed = limits['can_list'];
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Listing plan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('$plan  •  $used / $limit active listings'),
            if (allowed == false && limits['reason'] != null) ...[
              const SizedBox(height: 6),
              Text(limits['reason'].toString()),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubscriptionDetails extends StatelessWidget {
  final Map<String, dynamic> limits;
  final VoidCallback onManage;

  const _SubscriptionDetails({required this.limits, required this.onManage});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SubscriptionCard(limits: limits),
        const SizedBox(height: 12),
        const Text(
          'BuyCar sellers pay for subscription plans that set the number of vehicles they may list. The car sale takes place directly between the buyer and seller; this app does not collect the sale price or pay seller earnings.',
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onManage,
          child: const Text('View subscription plans'),
        ),
      ],
    );
  }
}

class _BuyerActivity extends StatelessWidget {
  const _BuyerActivity();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Offers'),
              Tab(text: 'Viewings'),
              Tab(text: 'Questions'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ActivityList(path: 'offers'),
                _ActivityList(path: 'viewings'),
                _ActivityList(path: 'questions'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityList extends StatefulWidget {
  final String path;

  const _ActivityList({required this.path});

  @override
  State<_ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<_ActivityList> {
  late Future<Response> _request;

  @override
  void initState() {
    super.initState();
    _request = Get.find<ApiClient>().getData(
      '/api/v1/buycar/vendor/${widget.path}?limit=30&offset=1',
      handleError: false,
    );
  }

  Future<void> _reload() async {
    final request = Get.find<ApiClient>().getData(
      '/api/v1/buycar/vendor/${widget.path}?limit=30&offset=1',
      handleError: false,
    );
    setState(() => _request = request);
    await request;
  }

  Future<void> _action(Map<String, dynamic> row, String action) async {
    final id = row['id'];
    final api = Get.find<ApiClient>();
    Response response;
    if (widget.path == 'offers') {
      response = await api.putData('/api/v1/buycar/vendor/offers/$id', {
        'status': action,
      }, handleError: false);
    } else if (widget.path == 'viewings') {
      response = await api.putData('/api/v1/buycar/vendor/viewings/$id', {
        'status': action,
      }, handleError: false);
    } else {
      final answer = await _answerQuestion();
      if (answer == null || answer.trim().isEmpty) return;
      response = await api.putData(
        '/api/v1/buycar/vendor/questions/$id/answer',
        {'answer': answer.trim()},
        handleError: false,
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.isOk
              ? 'Updated successfully.'
              : response.statusText ?? 'Unable to update this request.',
        ),
      ),
    );
    if (response.isOk) _reload();
  }

  Future<String?> _answerQuestion() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Answer question'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Your answer'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: _request,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final response = snapshot.data;
        if (response == null || !response.isOk) {
          return _LoadError(
            message: response?.statusText ?? 'Unable to load buyer activity.',
            onRetry: _reload,
          );
        }
        final body = response.body;
        final content = body is Map ? body['content'] : null;
        final data = content is Map ? content['data'] : null;
        final rows = data is List
            ? data.whereType<Map>().map(Map<String, dynamic>.from).toList()
            : <Map<String, dynamic>>[];
        if (rows.isEmpty) return const Center(child: Text('No activity yet.'));
        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final row = rows[index];
              final vehicle = row['vehicle'] is Map ? row['vehicle'] : {};
              final status = row['status']?.toString() ?? 'pending';
              final subtitle = widget.path == 'offers'
                  ? 'Buyer: ${row['buyer_name'] ?? 'Customer'}  •  KES ${row['offer_amount'] ?? ''}  •  $status${row['buyer_message'] == null ? '' : '\n${row['buyer_message']}'}'
                  : widget.path == 'viewings'
                  ? '${row['type'] ?? 'viewing'}  •  ${row['scheduled_at'] ?? row['requested_at'] ?? ''}  •  $status${row['buyer_license_number'] == null ? '' : '\nLicence: ${row['buyer_license_number']}'}${row['buyer_message'] == null ? '' : '\n${row['buyer_message']}'}'
                  : 'Question: ${row['question'] ?? ''}\nAnswer: ${row['answer'] ?? 'Unanswered'}';
              return Card(
                child: ListTile(
                  title: Text(
                    vehicle['name']?.toString() ??
                        row['question']?.toString() ??
                        'Buyer request',
                  ),
                  subtitle: Text(subtitle),
                  trailing: widget.path == 'offers' && status == 'pending'
                      ? PopupMenuButton<String>(
                          onSelected: (value) => _action(row, value),
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'accepted',
                              child: Text('Accept'),
                            ),
                            PopupMenuItem(
                              value: 'declined',
                              child: Text('Decline'),
                            ),
                          ],
                        )
                      : widget.path == 'viewings' && status == 'pending'
                      ? PopupMenuButton<String>(
                          onSelected: (value) => _action(row, value),
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'confirmed',
                              child: Text('Confirm'),
                            ),
                            PopupMenuItem(
                              value: 'declined',
                              child: Text('Decline'),
                            ),
                          ],
                        )
                      : widget.path == 'questions' && row['answer'] == null
                      ? IconButton(
                          tooltip: 'Answer',
                          onPressed: () => _action(row, 'answer'),
                          icon: const Icon(Icons.reply),
                        )
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _NewCarListingDialog extends StatefulWidget {
  final dynamic vehicleId;
  final Map<String, dynamic>? initial;

  const _NewCarListingDialog({this.vehicleId, this.initial});

  @override
  State<_NewCarListingDialog> createState() => _NewCarListingDialogState();
}

class _NewCarListingDialogState extends State<_NewCarListingDialog> {
  static const labels = [
    'front_3_4',
    'rear_3_4',
    'side_profile',
    'front_seats_dashboard',
    'back_seats',
    'odometer_reading',
  ];
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final Map<String, TextEditingController> _fields = {
    'name': TextEditingController(),
    'description': TextEditingController(),
    'model': TextEditingController(),
    'sale_price': TextEditingController(),
    'model_year': TextEditingController(),
    'mileage': TextEditingController(),
    'body_color': TextEditingController(),
    'engine_capacity': TextEditingController(),
    'seating_capacity': TextEditingController(),
    'registration_number': TextEditingController(),
    'vin_number': TextEditingController(),
    'engine_number': TextEditingController(),
    'first_registration_year': TextEditingController(),
    'previous_owners': TextEditingController(),
    'county': TextEditingController(),
  };
  List<XFile> _photos = [];
  String _condition = 'used';
  String _bodyType = 'saloon';
  String? _fuelType;
  String? _transmissionType;
  String? _serviceHistory;
  String? _importSource;
  List<Map<String, dynamic>> _brands = [];
  List<Map<String, dynamic>> _categories = [];
  String? _brandError;
  String? _categoryError;
  int? _brandId;
  int? _categoryId;
  bool _priceNegotiable = false;
  bool _airCondition = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      for (final entry in _fields.entries) {
        entry.value.text = initial[entry.key]?.toString() ?? '';
      }
      _condition = initial['condition']?.toString() ?? _condition;
      _bodyType = initial['body_type']?.toString() ?? _bodyType;
      _fuelType = initial['fuel_type']?.toString();
      _transmissionType = initial['transmission_type']?.toString();
      _serviceHistory = initial['service_history']?.toString();
      _importSource = initial['import_source']?.toString();
      _brandId = int.tryParse('${initial['brand_id'] ?? ''}');
      _categoryId = int.tryParse('${initial['category_id'] ?? ''}');
      _priceNegotiable = initial['price_negotiable'] == true;
      _airCondition = initial['air_condition'] == true;
    }
    _loadBrands();
    _loadCategories();
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final photos = await _picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (!mounted || photos.isEmpty) return;
    setState(() => _photos = photos.take(6).toList());
  }

  Future<void> _loadBrands() async {
    final response = await Get.find<ApiClient>().getData(
      '/api/v1/buycar/vendor/brand-list?limit=100&offset=1',
      handleError: false,
    );
    if (!mounted) return;
    final dynamic body = response.body;
    final dynamic content = body is Map ? body['content'] : null;
    final dynamic data = content is Map ? content['data'] : null;
    setState(() {
      _brands = data is List
          ? data.whereType<Map>().map(Map<String, dynamic>.from).toList()
          : [];
      if (!response.isOk || _brands.isEmpty) {
        _brandError = response.statusText ?? 'No vehicle brands are available.';
      }
    });
  }

  Future<void> _loadCategories() async {
    final response = await Get.find<ApiClient>().getData(
      '/api/v1/buycar/vendor/category-list?limit=100&offset=1',
      handleError: false,
    );
    if (!mounted) return;
    final dynamic body = response.body;
    final dynamic content = body is Map ? body['content'] : null;
    final dynamic data = content is Map ? content['data'] : null;
    setState(() {
      _categories = data is List
          ? data.whereType<Map>().map(Map<String, dynamic>.from).toList()
          : [];
      if (!response.isOk) {
        _categoryError =
            response.statusText ?? 'Unable to load vehicle categories.';
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_brandId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_brandError ?? 'Choose a vehicle brand.')),
      );
      return;
    }
    if (widget.vehicleId == null && _photos.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select six labelled vehicle photos.')),
      );
      return;
    }
    setState(() => _submitting = true);
    final fields = <String, String>{
      for (final entry in _fields.entries) entry.key: entry.value.text.trim(),
      'brand_id': '$_brandId',
      'condition': _condition,
      'body_type': _bodyType,
      'price_negotiable': _priceNegotiable ? '1' : '0',
      'air_condition': _airCondition ? '1' : '0',
      if (_categoryId != null) 'category_id': '$_categoryId',
      if (_fuelType != null) 'fuel_type': _fuelType!,
      if (_transmissionType != null) 'transmission_type': _transmissionType!,
      if (_serviceHistory != null) 'service_history': _serviceHistory!,
      if (_importSource != null) 'import_source': _importSource!,
    };
    final parts = <MultipartBody>[];
    if (_photos.isNotEmpty) {
      parts.add(MultipartBody('thumbnail', _photos.first));
      for (var index = 0; index < _photos.length; index++) {
        parts.add(MultipartBody('images[$index]', _photos[index]));
        fields['image_labels[$index]'] = labels[index];
      }
    }
    final updating = widget.vehicleId != null;
    final response = await Get.find<ApiClient>().postMultipartData(
      updating
          ? '/api/v1/buycar/vendor/vehicle/update/${widget.vehicleId}'
          : '/api/v1/buycar/vendor/vehicle/store',
      fields,
      parts,
      handleError: false,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (response.isOk) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.statusText ?? 'Unable to save listing.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.vehicleId == null ? 'List a vehicle' : 'Edit vehicle listing',
      ),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field('name', 'Listing title', required: true),
                _field('description', 'Description', maxLines: 4),
                DropdownButtonFormField<int>(
                  value: _brands.any((brand) => '${brand['id']}' == '$_brandId')
                      ? _brandId
                      : null,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  items: _brands
                      .map(
                        (brand) => DropdownMenuItem<int>(
                          value: int.tryParse('${brand['id']}'),
                          child: Text(brand['name']?.toString() ?? 'Brand'),
                        ),
                      )
                      .where((item) => item.value != null)
                      .toList(),
                  onChanged: (value) => setState(() => _brandId = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                _field('model', 'Model'),
                _field(
                  'sale_price',
                  'Asking price (KES)',
                  numeric: true,
                  required: true,
                ),
                _field(
                  'model_year',
                  'Model year',
                  numeric: true,
                  required: true,
                ),
                _field(
                  'mileage',
                  'Mileage (km)',
                  numeric: true,
                  required: true,
                ),
                _field('body_color', 'Colour', required: true),
                DropdownButtonFormField<String>(
                  value: _condition,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  items: const [
                    DropdownMenuItem(value: 'new', child: Text('New')),
                    DropdownMenuItem(value: 'used', child: Text('Used')),
                  ],
                  onChanged: (value) =>
                      setState(() => _condition = value ?? 'used'),
                ),
                DropdownButtonFormField<int>(
                  value:
                      _categories.any(
                        (category) => '${category['id']}' == '$_categoryId',
                      )
                      ? _categoryId
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    helperText: _categoryError,
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<int>(
                          value: int.tryParse('${category['id']}'),
                          child: Text(
                            category['name']?.toString() ?? 'Category',
                          ),
                        ),
                      )
                      .where((item) => item.value != null)
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                ),
                DropdownButtonFormField<String>(
                  value: _bodyType,
                  decoration: const InputDecoration(labelText: 'Body type'),
                  items:
                      const [
                            'saloon',
                            'suv',
                            'hatchback',
                            'pickup',
                            'van',
                            'wagon',
                            'coupe',
                            'convertible',
                            'mpv',
                            'bus',
                            'truck',
                            'other',
                          ]
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) =>
                      setState(() => _bodyType = value ?? 'other'),
                ),
                DropdownButtonFormField<String>(
                  value: _fuelType,
                  decoration: const InputDecoration(labelText: 'Fuel type'),
                  items: const ['petrol', 'diesel', 'hybrid', 'electric', 'lpg']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _fuelType = value),
                ),
                DropdownButtonFormField<String>(
                  value: _transmissionType,
                  decoration: const InputDecoration(labelText: 'Transmission'),
                  items: const ['automatic', 'manual']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _transmissionType = value),
                ),
                _field(
                  'engine_capacity',
                  'Engine capacity (cc)',
                  numeric: true,
                ),
                _field('seating_capacity', 'Seats', numeric: true),
                DropdownButtonFormField<String>(
                  value: _serviceHistory,
                  decoration: const InputDecoration(
                    labelText: 'Service history',
                  ),
                  items: const ['full', 'partial', 'none']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _serviceHistory = value),
                ),
                DropdownButtonFormField<String>(
                  value: _importSource,
                  decoration: const InputDecoration(labelText: 'Import source'),
                  items:
                      const [
                            'japan',
                            'uk',
                            'singapore',
                            'south_africa',
                            'dubai',
                            'local',
                            'other',
                          ]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value.replaceAll('_', ' ').toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _importSource = value),
                ),
                _field('county', 'County'),
                _field(
                  'first_registration_year',
                  'First registration year',
                  numeric: true,
                ),
                _field('previous_owners', 'Previous owners', numeric: true),
                _field('registration_number', 'Registration number'),
                _field('vin_number', 'VIN number'),
                _field('engine_number', 'Engine number'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Price is negotiable'),
                  value: _priceNegotiable,
                  onChanged: (value) =>
                      setState(() => _priceNegotiable = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Air conditioning'),
                  value: _airCondition,
                  onChanged: (value) => setState(() => _airCondition = value),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickPhotos,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(
                    _photos.isNotEmpty
                        ? '${_photos.length} new photos selected'
                        : widget.vehicleId == null
                        ? 'Select six required photos (0/6)'
                        : 'Add photos to listing',
                  ),
                ),
                if (_photos.isNotEmpty)
                  ...List.generate(
                    _photos.length,
                    (index) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(labels[index].replaceAll('_', ' ')),
                      subtitle: Text(_photos[index].name),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.vehicleId == null ? 'Submit listing' : 'Save changes',
                ),
        ),
      ],
    );
  }

  Widget _field(
    String key,
    String label, {
    bool numeric = false,
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: _fields[key],
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (value) => value == null || value.trim().isEmpty ? 'Required' : null
          : null,
    );
  }
}

class _LoadError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _LoadError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
