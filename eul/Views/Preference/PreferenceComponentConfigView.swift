//
//  PreferenceComponentConfigView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Localize_Swift
import SharedLibrary
import SwiftUI

extension Preference {
    struct ComponentTextConfigView<Component: Equatable & JSONCodabble & Hashable & LocalizedStringConvertible>: View {
        @EnvironmentObject var componentsStore: ComponentsStore<Component>

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Toggle(isOn: $componentsStore.showComponents) {
                        Text("component.show_text".localized())
                            .inlineSection()
                    }
                    Spacer()
                }
                HorizontalOrganizingView(componentsStore: componentsStore) { component in
                    HStack {
                        Text(component.localizedDescription)
                            .normal()
                    }
                }
            }
        }
    }

    struct ComponentConfigView: View {
        @EnvironmentObject var batteryStore: BatteryStore
        @EnvironmentObject var componentConfigStore: ComponentConfigStore
        @EnvironmentObject var diskStore: DiskStore
        @EnvironmentObject var networkStore: NetworkStore

        var component: EulComponent
        var config: Binding<EulComponentConfig> {
            $componentConfigStore[component]
        }

        var body: some View {
            SectionView(title: component.localizedDescription) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Toggle(isOn: config.showIcon) {
                            Text("component.show_icon".localized())
                                .inlineSection()
                        }
                        if config.wrappedValue.component.isGraphAvailable {
                            Toggle(isOn: config.showGraph) {
                                Text("component.show_graph".localized())
                                    .inlineSection()
                            }
                        }
                        if
                            config.wrappedValue.component.isDiskSelectionAvailable,
                            let disks = diskStore.list?.disks
                        {
                            Picker(
                                "disk.select".localized(),
                                selection: config.diskSelection
                            ) {
                                Text("disk.all".localized())
                                    .inlineSection()
                                    .tag("")
                                ForEach(disks) {
                                    Text($0.name)
                                        .inlineSection()
                                }
                            }
                            .frame(width: 200)
                        }
                        if
                            config.wrappedValue.component.isNetworkInterfaceSelectionAvailable
                        {
                            Picker(
                                "network.port.select".localized(),
                                selection: config.networkPortSelection
                            ) {
                                Text(networkStore.autoPortDesscription)
                                    .inlineSection()
                                    .tag("")
                                ForEach(networkStore.ports) {
                                    Text($0.description)
                                        .inlineSection()
                                }
                            }
                            .fixedSize()
                        }
                    }
                    if config.wrappedValue.component.isGraphAvailable && config.wrappedValue.showGraph {
                        HStack(spacing: 8) {
                            Text("Graph Color:")
                                .inlineSection()
                            ForEach(GraphColorOption.allCases, id: \.self) { option in
                                Button(action: {
                                    componentConfigStore[component].graphColor = option
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(option == .monochrome ? Color.text : option.color)
                                            .frame(width: 16, height: 16)
                                        if config.wrappedValue.graphColor == option {
                                            Circle()
                                                .strokeBorder(Color.primary, lineWidth: 2)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .help(option.label)
                            }
                        }
                    }
                    if component == .CPU {
                        ComponentTextConfigView<CpuTextComponent>()
                    }
                    if component == .GPU {
                        ComponentTextConfigView<GpuTextComponent>()
                    }
                    if component == .Memory {
                        ComponentTextConfigView<MemoryTextComponent>()
                    }
                    if SmcControl.shared.isFanValid, component == .Fan {
                        ComponentTextConfigView<FanTextComponent>()
                    }
                    if component == .Network {
                        ComponentTextConfigView<NetworkTextComponent>()
                    }
                    if batteryStore.isValid, component == .Battery {
                        ComponentTextConfigView<BatteryTextComponent>()
                    }
                    if component == .Disk {
                        ComponentTextConfigView<DiskTextComponent>()
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
