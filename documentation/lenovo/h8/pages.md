## Pages
***Note**: The offsets for these fields usually start at **0xa0** within the EC RAM once the corresponding page is set at offset **0x81**.*

| Page (BAT0)            | Page (BAT1) | Content / Function             |
| :--------------------- | :---------- | :----------------------------- |
| [**0x00**](#page-0x00) | 0x10        | **Dynamic Battery Data**       |
| [**0x01**](#page-0x01) | 0x11        | **Battery Management**         |
| [**0x02**](#page-0x02) | 0x12        | **Static Design Data**         |
| **0x03**               | 0x13        | Empty / Reserved               |
| [**0x04**](#page-0x04) | 0x14        | **Battery Technology**         |
| [**0x05**](#page-0x05) | 0x15        | **Battery OEM Information**    |
| [**0x06**](#page-0x06) | 0x16        | **Battery Model Information**  |
| [**0x07**](#page-0x07) | 0x17        | **Battery Serial Information** |
| [**0x08**](#page-0x08) | 0x18        | Unknown page details           |
| **0x09** - **0x0f**    | 0x19 - 0x1f | Empty / Reserved               |

### Page 0x00
| Address  | Name     | Width  | Unit     | Description                      | Notes                                            |
| :------- | :------- | :----- | :------- | :--------------------------------| :----------------------------------------------- |
| **0xa0** | **BARC** | 16-bit | 10 mWh   | **Battery Remaining Capacity**   |                                                  |
| **0xa2** | **BAFC** | 16-bit | 10 mWh   | **Battery Full Charge Capacity** |                                                  |
| **0xa4** |  [BART]  | 16-bit | min      | **Battery Remaining Time**       |                                                  |
| **0xa6** |  [BACP]  | 16-bit | %        | **Battery Capacity Percent**     |                                                  |
| **0xa8** | **BAPR** | 16-bit | 10 mW    | **Battery Present Rate**         | `>0`: Discharging <br /> `<0`: Charging          |
| **0xaa** | **BAVO** | 16-bit | mV       | **Battery Voltage**              |                                                  |
| **0xac** | ?        | 16-bit | ?        | ?                                |                                                  |
| **0xae** | ?        | 16-bit | ?        | ?                                |                                                  |

### Page 0x01
***Note**: According to coreboot, BIT(15) is BAMA.*

| Address  | Name     | Width   | Unit     | Description                      | Notes                                           |
| :------- | :------- | :------ | :------- | :------------------------------- | :---------------------------------------------- |
| **0xa0** | ?        | ?       | ?        | ?                                | Unknown!                                        |

### Page 0x02
| Address  | Name     | Width  | Unit     | Description                      | Notes                                            |
| :------- | :------- | :----- | :------- | :------------------------------- | :----------------------------------------------- |
| **0xa0** | **BADC** | 16-bit | 10 mWh   | **Battery Design Capacity**      |                                                  |
| **0xa2** | **BADV** | 16-bit | mV       | **Battery Design Voltage**       |                                                  |
| **0xa4** | ?        | 16-bit | ?        | ?                                |                                                  |
| **0xa6** | ?        | 16-bit | ?        | ?                                |                                                  |
| **0xa8** | ?        | 16-bit | ?        | ?                                |                                                  |
| **0xaa** | **BASN** | 16-bit | -        | **Battery Serial Number**        | Internal hardware serial or ID                   |
| **0xac** | ?        | 16-bit | ?        | ?                                |                                                  |
| **0xae** | ?        | 16-bit | ?        | ?                                |                                                  |

### Page 0x03
Empty/Reserved: All samples returned `0x00`.

### Page 0x04
| Address  | Name     | Width  | Unit     | Description                      | Notes                                            |
| :------- | :------- | :----- | :------- | :------------------------------- | :----------------------------------------------- |
| **0xa0** | **BATY** | 32-bit | ASCII    | **Battery Chemistry**            | `LION`: Li-Ion <br /> `LiP`: Li-Polymer          |
| **0xa4** | ?        | 96-bit | -        | Reserved / Padding               | All samples show `0x00`. Potentially reserved!   |

### Page 0x05
| Address  | Name     | Width   | Unit    | Description                      | Notes                                            |
| :------- | :------- | :------ | :------ | :------------------------------- | :----------------------------------------------- |
| **0xa0** | **BAOE** | 128-bit | ASCII   | **Battery OEM Information**      | Manufacturer (e.g. `SANYO`, `LGC`, `SONY`, …)    |

### Page 0x06
| Address  | Name     | Width   | Unit     | Description                      | Notes                                           |
| :------- | :------- | :------ | :------- | :------------------------------- | :---------------------------------------------- |
| **0xa0** | **BANA** | 128-bit | ASCII    | **Battery Model Name**           | FRU P/N                                         |

### Page 0x07
| Address  | Name     | Width   | Unit     | Description                      | Notes                                           |
| :------- | :------- | :------ | :------- | :------------------------------- | :---------------------------------------------- |
| **0xa0** |  [BASU]  | 128-bit | ASCII    | **Battery Serial Suffix**        | Individual part of barcode (starts after `Z`)   |

### Page 0x08
| Address  | Name     | Width   | Unit     | Description                      | Notes                                           |
| :------- | :------- | :------ | :------- | :------------------------------- | :---------------------------------------------- |
| **0xa0** | ?        | ?       | ?        | ?                                | Unknown!                                        |

### Page 0x09 - 0x0f
Empty/Reserved: All samples returned `0x00`.

## References
* [coreboot](https://github.com/coreboot/coreboot): `src/ec/lenovo/h8`, …
* [Linux Kernel](https://github.com/torvalds/linux): `drivers/platform/x86/lenovo/thinkpad_acpi.c`, …
* [tp_smapi](https://github.com/linux-thinkpad/tp_smapi)
