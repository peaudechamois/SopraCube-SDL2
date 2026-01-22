# SopraCube2 (C + SDL2, Windows x64, VS Code)

This is a minimal C project for **Windows 64-bit** built in **Visual Studio Code** using **CMake**.

SDL2 is compiled **from local sources** (downloaded into `third_party/SDL2`) so the project can build SDL2 “on the fly”.

## 1) Prerequisites (Windows x64)

Note: **Visual Studio Code is not the compiler/toolchain.** You still need **Visual Studio 2022** (Community) or **Visual Studio Build Tools 2022** with the C++ workload so CMake can use the `Visual Studio 17 2022` generator.

### Toolchain (compiler)
Pick **one**:

- **Recommended:** Visual Studio Build Tools 2022 (MSVC)
  - Install: https://visualstudio.microsoft.com/downloads/
  - In the installer, select **“Desktop development with C++”**
  - Ensure these components are included:
    - MSVC v143 toolset
    - Windows 10/11 SDK

### Build tooling
- **CMake** (>= 3.21): https://cmake.org/download/
- **Git** (optional but recommended): https://git-scm.com/download/win
- **PowerShell** (already on Windows; script uses `Invoke-WebRequest` + `Expand-Archive`)

After installing CMake, make sure it is on your `PATH`:

```powershell
cmake --version
```

### Visual Studio Code extensions
Install these in VS Code:
- **C/C++** (`ms-vscode.cpptools`)
- **CMake Tools** (`ms-vscode.cmake-tools`)

## 2) Enable VS Code to compile C

1. Install the prerequisites above (MSVC + CMake).
2. Open this folder in VS Code.
3. If you see prompts from **CMake Tools**, accept them.
4. Configure the project (any of these options):
   - Command Palette → **“CMake: Configure”**
   - or run the task **“CMake: Configure (msvc-x64)”**

If configuration fails with “compiler not found”, try launching VS Code from:
- **“x64 Native Tools Command Prompt for VS 2022”**

## 3) Download SDL2 sources locally (so it builds from source)

This project expects SDL2 sources at:
- `third_party/SDL2`

To download them automatically, run in a PowerShell terminal from the repo root:

```powershell
.\scripts\fetch_sdl2.ps1 -Version 2.30.10
```

What this does:
- Downloads the official SDL2 release source zip from GitHub
- Extracts it
- Copies it into `third_party/SDL2`

### Alternate: manually add SDL2 sources
If you already have SDL2 sources:
1. Create the folder `third_party/SDL2`
2. Copy the SDL2 source tree there so that this exists:
   - `third_party/SDL2/CMakeLists.txt`

## 4) Build + run from VS Code

### Option A (recommended): CMake Tools UI
- Command Palette → **CMake: Build**
- Command Palette → **CMake: Run Without Debugging** (or use the Run/Debug panel)

### Option B: VS Code tasks
- Build: `Ctrl+Shift+B` → **CMake: Build (Debug)**
- Run: run task **Run: SopraCube2 (Debug)**

### Option C: CLI
```powershell
cmake --preset msvc-x64
cmake --build --preset debug
.\build\msvc-x64\Debug\SopraCube2.exe
```

## 5) How SDL2 is compiled “on the fly”

This project builds SDL2 directly from sources by doing:
- `add_subdirectory(third_party/SDL2)` in CMake

So SDL2 gets compiled as part of your normal configure/build steps (no separate install step required).

## Notes
- This project links SDL2 **statically** by default to avoid DLL copying.
- If you prefer a shared SDL2 build later, we can switch the CMake options and add a post-build copy step for `SDL2.dll`.
- By default, `.gitignore` excludes `third_party/SDL2` (downloaded sources). Remove that ignore entry if you want to commit SDL2 sources into your repository.

## Troubleshooting

### VS Code is installed, but CMake can’t find “Visual Studio 17 2022”

VS Code version doesn’t matter here — the error means the **MSVC toolchain** is missing or CMake is being pointed at the wrong install.

On the failing machine, run:

```powershell
.cscriptscdiagnose_toolchain.ps1
```

If it reports no instance with MSVC C++ tools, install **Build Tools 2022** (or VS 2022) with **Desktop development with C++**.

### CMake says it can’t find the Visual Studio instance

If you see an error like:

> Generator `Visual Studio 17 2022` could not find specified instance of Visual Studio: `.../Microsoft Visual Studio/18/BuildTools`

It usually means an environment variable is forcing CMake to use a VS 18 (2026) instance while the generator is VS 17 (2022).

Fix options:
- Delete the preset build folder and re-configure (recommended):

```powershell
Remove-Item -Recurse -Force .\build\msvc-x64 -ErrorAction SilentlyContinue
cmake --preset msvc-x64
```

- Or (CMake 3.24+): re-configure from scratch with `--fresh`:

```powershell
cmake --preset msvc-x64 --fresh
```

- Open a **new** terminal and run `cmake --preset msvc-x64` again.
- In PowerShell, temporarily clear the variable for the current terminal:

```powershell
Remove-Item Env:CMAKE_GENERATOR_INSTANCE -ErrorAction SilentlyContinue
```

- Or remove/adjust `CMAKE_GENERATOR_INSTANCE` in Windows System Environment Variables.

Note: If you have multiple Visual Studio installs and CMake keeps picking the wrong one, you *can* set `CMAKE_GENERATOR_INSTANCE` to your actual VS install folder (e.g. `...\Microsoft Visual Studio\2022\Community` or `...\2022\BuildTools`). If you see “could not find any instance of Visual Studio”, clear `CMAKE_GENERATOR_INSTANCE` and re-configure.
