/*++

Copyright (c) 2014 Minoca Corp.

    This file is licensed under the terms of the GNU General Public License
    version 3. Alternative licensing terms are available. Contact
    info@minocacorp.com for details. See the LICENSE file at the root of this
    project for complete licensing information.

Module Name:

    Integrator UEFI Runtime

Abstract:

    This module implements the Integrator runtime firmware, which continues
    running even after boot services have been torn down. It is never unloaded.

Author:

    Evan Green 7-Apr-2014

Environment:

    Firmware

--*/

function build() {
    sources = [
        "rtc.c",
        "runtime.c"
    ];

    libs = [
        "//uefi/dev/pl031:pl031",
        "//uefi/core/rtlib:rtlib",
        "//uefi/archlib:uefiarch",
    ];

    includes = [
        "$//uefi/include"
    ];

    sources_config = {
        "CFLAGS": ["-fshort-wchar"],
    };

    link_ldflags = [
        "-pie",
        "-nostdlib",
        "-Wl,--no-wchar-size-warning",
        "-static"
    ];

    link_config = {
        "LDFLAGS": link_ldflags
    };

    elf = {
        "label": "integrt.elf",
        "inputs": sources + libs,
        "sources_config": sources_config,
        "includes": includes,
        "entry": "EfiRuntimeCoreEntry",
        "linker_script": "$//uefi/include/link_arm.x",
        "config": link_config
    };

    entries = executable(elf);
    entries += uefi_runtime_ffs("integrt");
    return entries;
}

return build();
