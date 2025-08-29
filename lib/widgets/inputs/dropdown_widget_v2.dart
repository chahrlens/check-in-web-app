import 'package:get/get.dart';
import '../commons/loading.dart';
import 'autocomplete_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/models/has_id_label.dart';
import 'package:qr_check_in/models/dropdown_option_model.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';

class GenericLoadingAutocompleteDropdown<T extends HasIdLabel>
    extends StatefulWidget {
  final RxBool isLoading;
  final List<T> items;
  final Function(T) onSelected;
  final String label;
  final String hintText;
  final Rx<T?> resetValue;
  final double width;
  final Future<List<T>> Function(String)? onTextChange;
  final bool enabled;
  final IconData prefixIcon;
  final String loadingText;
  final T? initialValue;
  final String? Function(T?)? validator;
  final TextEditingController? controller;

  const GenericLoadingAutocompleteDropdown({
    super.key,
    required this.isLoading,
    required this.items,
    required this.onSelected,
    required this.label,
    required this.hintText,
    required this.resetValue,
    required this.width,
    required this.enabled,
    this.onTextChange,
    this.prefixIcon = Icons.person_outline,
    this.loadingText = '',
    this.initialValue,
    this.validator,
    this.controller,
  });

  @override
  State<GenericLoadingAutocompleteDropdown<T>> createState() =>
      _GenericLoadingAutocompleteDropdownState<T>();
}

class _GenericLoadingAutocompleteDropdownState<T extends HasIdLabel>
    extends State<GenericLoadingAutocompleteDropdown<T>> {
  DropDownOption<dynamic>? _initialValue;
  List<DropDownOption<T>> _convertToDropDownOptions(List<T> items) {
    return items
        .map(
          (item) => DropDownOption<T>(
            id: item.identifier,
            label: item.identifierLabel,
            value: item,
          ),
        )
        .toList();
  }

  List<T> _defaultFilter(String query) {
    if (query.isEmpty) return widget.items;

    return widget.items.where((item) {
      final idMatches = item.identifier.toLowerCase().contains(
        query.toLowerCase(),
      );
      final labelMatches = item.identifierLabel.toLowerCase().contains(
        query.toLowerCase(),
      );
      return idMatches || labelMatches;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null) {
        _initialValue = DropDownOption<T>(
          id: widget.initialValue!.identifier,
          label: widget.initialValue!.identifierLabel,
          value: widget.initialValue!,
        );
      } else {
        _initialValue = null;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.isLoading.value || widget.items.isEmpty) {
        return SizedBox(
          width: widget.width,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.loadingText,
                  style: CustomStyle.hintTextStyleBlack(context),
                ),
                const Loading(),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        width: widget.width,
        child: AutocompleteDropdownWidget(
          key: ValueKey(widget.initialValue?.identifier),
          validator: widget.validator != null
              ? (value) => widget.validator?.call(value?.value as T?)
              : null,
          initialValue: _initialValue,
          prefixIcon: widget.prefixIcon,
          enabled: widget.enabled,
          listItems: _convertToDropDownOptions(widget.items),
          textController: widget.controller,
          onSelected: (option) {
            final opt = option as DropDownOption<T>;
            return widget.onSelected(opt.value as T);
          },
          label: widget.label,
          hintText: widget.hintText,
          onFocusChange: (hasFocus) {},
          resetClean: (clean) {
            widget.resetValue.value = widget.items.first;
          },
          onTextChange: (text) async {
            if (widget.onTextChange != null) {
              final filteredItems = await widget.onTextChange!(text);
              return _convertToDropDownOptions(filteredItems);
            }

            return _convertToDropDownOptions(_defaultFilter(text));
          },
        ),
      );
    });
  }
}
