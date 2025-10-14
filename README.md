
# Alicia Floristas (Flutter)

Multiplataforma (Android/iOS/iPadOS). Funciones: OCR desde foto, dictado por voz, búsqueda por nº o nombre y exportación a Excel.

## Requisitos
- Flutter SDK instalado
- Dispositivo Android/iOS o emulador

## Primeros pasos
```bash
flutter pub get
flutter run
```
En producción usa Codemagic con `codemagic.yaml` o su UI.

## Estructura de pantallas
- HomeScreen: navegación principal
- NewNotePhotoScreen: foto -> OCR -> revisión -> guardar
- NewNoteVoiceScreen: dictado -> revisión -> guardar
- SearchOrderScreen: búsqueda por número o nombre
- ExportExcelScreen: selección y exportación a .xlsx
```
