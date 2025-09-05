import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/views/guests/controllers/guest_controller.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';

class FamilySelectorWidget extends StatelessWidget {
  final double width;
  const FamilySelectorWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageGuestController>(
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runAlignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: width,
                child: Column(
                  children: [
                    DropdownButton<Family?>(
                      isExpanded: true,
                      value: controller.selectedFamily.value,
                      hint: Text('Selecciona una familia'),
                      items: [
                        ...controller.families.map(
                          (family) => DropdownMenuItem(
                            value: family,
                            child: Text(family.name),
                          ),
                        ),
                        DropdownMenuItem(
                          value: null,
                          child: Text('Crear nueva familia'),
                        ),
                      ],
                      onChanged: (value) {
                        controller.setTableDataWithFamily(value);
                      },
                    ),
                    if (controller.selectedFamily.value == null) ...[
                      SizedBox(height: 12),
                      CustomInputWidget(
                        controller: controller.familyNameCtrl,
                        hintText: 'Nombre de la nueva familia',
                        label: 'Nombre de la nueva familia',
                        prefixIcon: Icons.family_restroom,
                      ),
                    ],
                  ],
                ),
              ),
              if (controller.selectedFamily.value == null)
                SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      Text('Selecciona mesas para la familia:'),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.eventTables.map((table) {
                            final isSelected = controller.selectedTables
                                .contains(table);
                            return FilterChip(
                              label: Text('${table.name}: ${table.capacity}'),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  controller.selectedTables.add(table);
                                } else {
                                  controller.selectedTables.remove(table);
                                }
                                controller.updateTableStatics();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.selectedFamily.value != null)
                SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      Text('Selecciona mesas adicionales para la familia:'),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.eventTables
                              .where(
                                (t) =>
                                    controller.getAssociatedTableIds().contains(
                                      t.id,
                                    ) ==
                                    false,
                              )
                              .map((table) {
                                final isSelected = controller.selectedTables
                                    .contains(table);
                                return FilterChip(
                                  label: Text(
                                    '${table.name}: ${table.capacity}',
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      controller.selectedTables.add(table);
                                    } else {
                                      controller.selectedTables.remove(table);
                                    }
                                    controller.updateTableStatics();
                                  },
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
