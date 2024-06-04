import { invokeNomoFunction, isFallbackModeActive } from "./dart_interface.js";
/**
 * Switches the Nomo App to a different theme.
 * It is recommended to call "injectNomoCSSVariables" after a theme has changed.
 */
export async function switchNomoTheme(args) {
    if (isFallbackModeActive()) {
        localStorage.setItem("nomoTheme", args.theme);
    }
    else {
        return await invokeNomoFunction("nomoSwitchTheme", args);
    }
}
/**
 * "nomoGetDartColors" is a low-level function that should not be called directly. Use "getCurrentNomoTheme" instead.
 */
async function nomoGetDartColors() {
    return await invokeNomoFunction("nomoGetTheme", null);
}
/**
 * A low-level function. We recommend using "injectNomoCSSVariables" instead.
 */
export async function getCurrentNomoTheme() {
    var _a;
    if (isFallbackModeActive()) {
        const fallbackThemeSelector = (_a = localStorage.getItem("nomoTheme")) !== null && _a !== void 0 ? _a : "LIGHT";
        if (fallbackThemeSelector === "LIGHT") {
            return lightTheme;
        }
        else if (fallbackThemeSelector === "DARK") {
            return darkTheme;
        }
        else if (fallbackThemeSelector === "AVINOC") {
            return avinocTheme;
        }
        else if (fallbackThemeSelector === "TUPAN") {
            return tupanTheme;
        }
        else {
            return Promise.reject("unknown fallback theme " + fallbackThemeSelector); // should never happen
        }
    }
    const rawTheme = await nomoGetDartColors();
    const colors = rawTheme.colors;
    for (const color of Object.entries(colors)) {
        colors[color[0]] = convertFlutterColorIntoCSSColor(color[1]);
    }
    return rawTheme;
}
function capitalizeFirstLetter(inputString) {
    if (!inputString.length)
        return inputString;
    return inputString.charAt(0).toUpperCase() + inputString.slice(1);
}

// const lightTheme = {
//     name: "LIGHT",
//     displayName: "Nomo Light",
//     colors: {
//         primary: "#bca570",
//         brightness: 1,
//         onPrimary: "#ffffff",
//         primaryContainer: "#fcfaf7",
//         secondary: "#d1af72",
//         onSecondary: "#000000",
//         secondaryContainer: "#e6d0a3",
//         background1: "#f5f5f5",
//         background2: "#f0f0f0",
//         background3: "#e6e6e6",
//         surface: "#ffffff",
//         error: "#ff5252",
//         disabled: "#e0e0e0",
//         onDisabled: "#9e9e9e",
//         foreground1: "#cf000000",
//         foreground2: "#df000000",
//         foreground3: "#ef000000"
//     }
// }
// const darkTheme = {
//     name: "DARK",
//     displayName: "Nomo Dark",
//     colors: {
//         primary: "#bca570",
//         brightness: 0,
//         onPrimary: "#ffffff",
//         primaryContainer: "#fcfaf7",
//         secondary: "#d1af72",
//         onSecondary: "#000000",
//         secondaryContainer: "#e6d0a3",
//         background1: "#293138",
//         background2: "#1e2428",
//         background3: "#13191d",
//         surface: "#2e363c",
//         error: "#ff5252",
//         disabled: "#e0e0e0",
//         onDisabled: "#9e9e9e",
//         foreground1: "#eaffffff",
//         foreground2: "#f0ffffff",
//         foreground3: "#faffffff"
//     },
// };

// const avinocTheme = {
//     name: "AVINOC",
//     displayName: "AVINOC",
//     colors: {
//         primary: "#2faaa5",
//         brightness: 0,
//         onPrimary: "#ffffff",
//         primaryContainer: "#cafffd",
//         secondary: "#2faaa5",
//         onSecondary: "#1c1c1c",
//         secondaryContainer: "#992faaa5",
//         background1: "#272f4a",
//         background2: "#333a66",
//         background3: "#232846",
//         surface: "#101d42",
//         error: "#ff5252",
//         disabled: "#e0e0e0",
//         onDisabled: "#9e9e9e",
//         foreground1: "#eaffffff",
//         foreground2: "#f0ffffff",
//         foreground3: "#faffffff"
//     },
// };
// const tupanTheme = {
//     name: "TUPAN",
//     displayName: "TUPAN",
//     colors: {
//         primary: "#77af22",
//         brightness: 0,
//         onPrimary: "#ffffff",
//         primaryContainer: "#efffd8",
//         secondary: "#77af22",
//         onSecondary: "#1c1c1c",
//         secondaryContainer: "#2b400d",
//         background1: "#0e1504",
//         background2: "#486a15",
//         background3: "#578019",
//         surface: "#1d2b08",
//         error: "#ff5252",
//         disabled: "#e0e0e0",
//         onDisabled: "#9e9e9e",
//         foreground1: "#fcffffff",
//         foreground2: "#faffffff",
//         foreground3: "#f0ffffff"
//     },
// };
const lightTheme = {
    name: "LIGHT",
    displayName: "Nomo Light",
    colors: {
        primary: "#bca570ff",
        onPrimary: "#ffffffff",
        primaryContainer: "#fcfaf7ff",
        secondary: "#d1af72ff",
        onSecondary: "#000000ff",
        secondaryContainer: "#e6d0a3ff",
        background1: "#f5f5f5ff",
        background2: "#f5f5f5ff",
        background3: "#f5f5f5ff",
        surface: "#ffffffff",
        foreground1: "#000000cf",
        foreground2: "#000000df",
        foreground3: "#000000ef",
        snackBarColor: "#fff7e5ff",
        disabledColor: "#e0e0e0ff",
        error: "#ff5252ff",
        settingsTileColor: "#ffffffff",
        settingsColumnColor: "#edededff",
        brightness: 1,
    },
};
const darkTheme = {
    name: "DARK",
    displayName: "Nomo Dark",
    colors: {
        primary: "#bca570ff",
        onPrimary: "#ffffffff",
        primaryContainer: "#fcfaf7ff",
        secondary: "#d1af72ff",
        onSecondary: "#000000ff",
        secondaryContainer: "#e6d0a3ff",
        background1: "#293138ff",
        background2: "#293138ff",
        background3: "#293138ff",
        surface: "#2e363cff",
        foreground1: "#ffffffea",
        foreground2: "#fffffff0",
        foreground3: "#fffffffa",
        snackBarColor: "#474a53ff",
        disabledColor: "#e0e0e0ff",
        error: "#ff5252ff",
        settingsTileColor: "#4b5a66ff",
        settingsColumnColor: "#38434cff",
        brightness: 0,
    },
};
const avinocTheme = {
    name: "AVINOC",
    displayName: "AVINOC",
    colors: {
        primary: "#2faaa5ff",
        onPrimary: "#ffffffff",
        primaryContainer: "#cafffdff",
        secondary: "#2faaa5ff",
        onSecondary: "#1c1c1cff",
        secondaryContainer: "#1c1c1cff",
        background1: "#272f4aff",
        background2: "#272f4aff",
        background3: "#272f4aff",
        surface: "#101d42ff",
        foreground1: "#ffffffea",
        foreground2: "#fffffff0",
        foreground3: "#fffffffa",
        snackBarColor: "#333a66ff",
        disabledColor: "#e0e0e0ff",
        error: "#ff5252ff",
        settingsTileColor: "#333a66ff",
        settingsColumnColor: "#232846ff",
        brightness: 0,
    },
};
const tupanTheme = {
    name: "TUPAN",
    displayName: "TUPAN",
    colors: {
        primary: "#77af22ff",
        onPrimary: "#ffffffff",
        primaryContainer: "#efffd8ff",
        secondary: "#77af22ff",
        onSecondary: "#1c1c1cff",
        secondaryContainer: "#1c1c1cff",
        background1: "#417030ff",
        background2: "#417030ff",
        background3: "#417030ff",
        surface: "#346231ff",
        foreground1: "#ffffffea",
        foreground2: "#fffffff0",
        foreground3: "#fffffffa",
        snackBarColor: "#4a8037ff",
        disabledColor: "#e0e0e0ff",
        error: "#ff5252ff",
        settingsTileColor: "#4a8037ff",
        settingsColumnColor: "#417030ff",
        brightness: 0,
    },
};
/**
 * Injects CSS variables that automatically adjust according to the currently selected Nomo theme.
 */
export async function injectNomoCSSVariables() {
    const htmlTag = document.getElementsByTagName("html");
    if (!htmlTag) {
        return Promise.reject("did not find HTML tag for injection");
    }
    const theme = await getCurrentNomoTheme();
    Object.entries(theme.colors).forEach((entry) => {
        const varName = "--nomo" + capitalizeFirstLetter(entry[0]);
        const color = entry[1];
        htmlTag[0].style.setProperty(varName, color);
    });
}
function convertFlutterColorIntoCSSColor(flutterColor) {
    if (!flutterColor.startsWith("0x")) {
        return flutterColor; // should never happen
    }
    let cssColor = flutterColor.replace("0x", "");
    if (cssColor.length >= 8) {
        // move alpha channel to the last position
        cssColor = cssColor.substring(2) + cssColor.substring(0, 2);
    }
    return "#" + cssColor;
}

window.getCurrentNomoTheme = getCurrentNomoTheme;
window.switchNomoTheme = switchNomoTheme;
window.injectNomoCSSVariables = injectNomoCSSVariables;
