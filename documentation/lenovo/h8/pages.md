## Pages
> [!NOTE]
> The offsets for these fields usually start at **0xa0** within the EC RAM once the corresponding page is set at offset **0x81**.

| Page (BAT0)            | Page (BAT1) | Description                    | Notes                                                 |
| :--------------------- | :---------- | :----------------------------- | :---------------------------------------------------- |
| [**0x00**](#page-0x00) | 0x10        | **Dynamic Battery Data**       |                                                       |
| [**0x01**](#page-0x01) | 0x11        | **Battery Management**         | Unknown page details                                  |
| [**0x02**](#page-0x02) | 0x12        | **Static Design Data**         |                                                       |
| **0x03**               | 0x13        | -                              | Empty / Reserved                                      |
| [**0x04**](#page-0x04) | 0x14        | **Battery Technology**         |                                                       |
| [**0x05**](#page-0x05) | 0x15        | **Battery OEM Information**    |                                                       |
| [**0x06**](#page-0x06) | 0x16        | **Battery Model Information**  |                                                       |
| [**0x07**](#page-0x07) | 0x17        | **Battery Serial Information** |                                                       |
| [**0x08**](#page-0x08) | 0x18        | ?                              | Unknown page details                                  |
| **0x09** - **0x0f**    | 0x19 - 0x1f | -                              | Empty / Reserved                                      |

| Page                                 | Description                    | Notes                                                 |
| :----------------------------------- | :----------------------------- | :---------------------------------------------------- |
| **0x20** - **0x3f**                  | ?                              | Unknown page details                                  |
| **0x40** - ...                       | -                              | Empty / Reserved                                      |

### Summary
#### Battery
<table>
	<thead>
		<tr>
			<th>Page</th>
			<th>Offset</th>
			<th>+0</th>
			<th>+1</th>
			<th>+2</th>
			<th>+3</th>
			<th>+4</th>
			<th>+5</th>
			<th>+6</th>
			<th>+7</th>
			<th>+8</th>
			<th>+9</th>
			<th>+a</th>
			<th>+b</th>
			<th>+c</th>
			<th>+d</th>
			<th>+e</th>
			<th>+f</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><a href="#page-0x00"><b>0x00</b></a> / <b>0x10</b></td>
			<td><code>0xa0</code></td>
			<td colspan="2"><b>BARC</b></td>
			<td colspan="2"><b>BAFC</b></td>
			<td colspan="2">[BART]</td>
			<td colspan="2">[BACP]</td>
			<td colspan="2"><b>BAPR</b></td>
			<td colspan="2"><b>BAVO</b></td>
			<td colspan="2">?</td>
			<td colspan="2">?</td>
		</tr>
		<tr>
			<td><a href="#page-0x01"><b>0x01</b></a> / <b>0x11</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">?</td>
		</tr>
		<tr>
			<td><a href="#page-0x02"><b>0x02</b></a> / <b>0x12</b></td>
			<td><code>0xa0</code></td>
			<td colspan="2"><b>BADC</b></td>
			<td colspan="2"><b>BADV</b></td>
			<td colspan="2">?</td>
			<td colspan="2">?</td>
			<td colspan="2">?</td>
			<td colspan="2"><b>BASN</b></td>
			<td colspan="2">?</td>
			<td colspan="2">?</td>
		</tr>
		<tr>
			<td><b>0x03</b> / <b>0x13</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">(Empty / Reserved)</td>
		</tr>
		<tr>
			<td><a href="#page-0x04"><b>0x04</b></a> / <b>0x14</b></td>
			<td><code>0xa0</code></td>
			<td colspan="4"><b>BATY</b></td>
			<td colspan="12">(Reserved / Padding)</td>
		</tr>
		<tr>
			<td><a href="#page-0x05"><b>0x05</b></a> / <b>0x15</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16"><b>BAOE</b></td>
		</tr>
		<tr>
			<td><a href="#page-0x06"><b>0x06</b></a> / <b>0x16</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16"><b>BANA</b></td>
		</tr>
		<tr>
			<td><a href="#page-0x07"><b>0x07</b></a> / <b>0x17</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">[BASU]</td>
		</tr>
		<tr>
			<td><a href="#page-0x08"><b>0x08</b></a> / <b>0x18</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">?</td>
		</tr>
		<tr>
			<td><b>0x09</b> - <b>0x0f</b> <br /> <b>0x19</b> - <b>0x1f</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">(Empty / Reserved)</td>
		</tr>
		<tr>
			<td><b>0x20</b> - <b>0x3f</b> <br /> <b>0x19</b> - <b>0x1f</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">?</td>
		</tr>
		<tr>
			<td><b>0x40</b> - <b>0x4f</b> <br /> <b>0x19</b> - <b>0x1f</b></td>
			<td><code>0xa0</code></td>
			<td colspan="16">(Empty / Reserved)</td>
		</tr>
	</tbody>
</table>

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
> [!TIP]
> According to coreboot, BIT(15) is BAMA.

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
> [!WARNING]
> Empty/Reserved: All samples returned `0x00`.

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
> [!WARNING]
> Empty/Reserved: All samples returned `0x00`.

## References
* [coreboot](https://github.com/coreboot/coreboot): `src/ec/lenovo/h8`, …
* [Linux Kernel](https://github.com/torvalds/linux): `drivers/platform/x86/lenovo/thinkpad_acpi.c`, …
* [tp_smapi](https://github.com/linux-thinkpad/tp_smapi)
