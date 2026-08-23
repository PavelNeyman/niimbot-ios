//
//  BarcodeTypeSelector.swift
//  NiimBlueiOS
//
//  Контроллер выбора типа штрихкода
//

import SwiftUI

/// Выбор типа штрихкода
/// - Returns: Контроллер для выбора типа штрихкода
struct BarcodeTypeSelector: View {
    
    // MARK: - Properties
    
    @Binding var selectedType: BarcodeType
    @Binding var showPicker: Bool
    var label: String = "Barcode Type"
    var showLabel: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            if showLabel {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            Picker("", selection: Binding(
                get: { selectedType },
                set: { selectedType = $0 }
            )) {
                ForEach(BarcodeType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .cornerRadius(6)
            .onChange(of: showPicker) { _, newValue in
                if newValue {
                    selectedType = .code128
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Preview

struct BarcodeTypeSelector_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeTypeSelector(
            selectedType: .constant(.code128),
            showPicker: .constant(true)
        )
        .frame(width: 300, height: 150)
        .padding()
    }
}
