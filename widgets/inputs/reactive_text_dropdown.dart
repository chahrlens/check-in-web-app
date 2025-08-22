import 'package:get/get.dart';
import '../commons/loading.dart';
import 'custom_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_check_in/models/dropdown_option_model.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';
import 'package:qr_check_in/shared/resources/dimensions.dart';

typedef OnTextChangeCallback = Future<List<DropDownOption>> Function(String);

class ReactiveAutocompleteDropdown extends StatefulWidget {
  final RxBool isLoading;
  final Rx<DropDownOption> selectedValue;
  final List<DropDownOption> listItems;
  final Function(DropDownOption) onSelected;
  final String label;
  final String hintText;
  final double width;
  final OnTextChangeCallback onTextChange;
  final bool enabled;
  final IconData prefixIcon;
  final String loadingText;
  final String? Function(DropDownOption?)? validator;

  const ReactiveAutocompleteDropdown({
    super.key,
    required this.isLoading,
    required this.selectedValue,
    required this.listItems,
    required this.onSelected,
    required this.label,
    required this.hintText,
    required this.width,
    required this.enabled,
    required this.onTextChange,
    this.prefixIcon = Icons.person_outline,
    this.loadingText = '',
    this.validator,
  });

  @override
  State<ReactiveAutocompleteDropdown> createState() =>
      _ReactiveAutocompleteDropdownState();
}

class _ReactiveAutocompleteDropdownState
    extends State<ReactiveAutocompleteDropdown> {
  late TextEditingController textEditingController;
  DropDownOption? selectedOption;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    updateSelectedOption();
  }

  @override
  void didUpdateWidget(covariant ReactiveAutocompleteDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue.value.id != oldWidget.selectedValue.value.id ||
        widget.listItems != oldWidget.listItems) {
      updateSelectedOption();
    }
  }

  void updateSelectedOption() {
    final optionSelected = widget.listItems.firstWhere(
      (option) => option.id.toString() == widget.selectedValue.value.id.toString(),
      orElse: () => DropDownOption(id: '', label: ''),
    );

    setState(() {
      selectedOption = optionSelected;
      textEditingController.text = selectedOption?.label ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.isLoading.value || widget.listItems.isEmpty) {
        return SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.loadingText,
                style: CustomStyle.hintTextStyleBlack(context),
              ),
              const Loading(),
            ],
          ),
        );
      }

      return SizedBox(
        width: widget.width,
        child: FormField<DropDownOption>(
          initialValue: selectedOption ?? widget.selectedValue.value,
          validator: widget.validator,
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<DropDownOption> fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Autocomplete<DropDownOption>(
                  initialValue: TextEditingValue(
                    text: selectedOption?.label ?? '',
                  ),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (fieldState.value == null && selectedOption != null) {
                      fieldState.didChange(selectedOption);
                    }
                    return widget.onTextChange(textEditingValue.text);
                  },
                  onSelected: (DropDownOption option) {
                    setState(() {
                      selectedOption = option;
                      textEditingController.text = option.label;
                    });
                    widget.selectedValue.value = option;
                    fieldState.didChange(option);
                    widget.onSelected(option);
                  },
                  displayStringForOption: (DropDownOption option) => option.label,
                  fieldViewBuilder: (
                    BuildContext context,
                    textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return CustomInputWidget(
                      enabled: widget.enabled,
                      onFocusChangeInput: (_) {},
                      focusNode: focusNode,
                      onFieldSubmitted: (_) => onFieldSubmitted(),
                      controller: this.textEditingController,
                      label: widget.label,
                      hintText: widget.hintText,
                      prefixIcon: widget.prefixIcon,
                    );
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<DropDownOption> onSelected,
                    Iterable<DropDownOption> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  widget.onSelected(option);
                                  fieldState.didChange(option);
                                  onSelected(option);
                                },
                                child: Builder(builder: (context) {
                                  final bool highlight =
                                      AutocompleteHighlightedOption.of(context) ==
                                          index;
                                  if (highlight) {
                                    SchedulerBinding.instance.addPostFrameCallback((_) {
                                      Scrollable.ensureVisible(context,
                                          alignment: 0.5);
                                    });
                                  }
                                  return Container(
                                    color: highlight
                                        ? Theme.of(context).focusColor
                                        : null,
                                    padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                                    child: Text(option.label),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (fieldState.hasError)
                  Text(
                    fieldState.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: Dimensions.smallTextSize,
                    ),
                  ),
              ],
            );
          },
        ),
      );
    });
  }
}
