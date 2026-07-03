# Creating & Managing Snapshots

The USBridge-KVM 2.0 snapshot workflow is architected to capture, seal, and preserve historical data states on external, hardware-isolated storage media. For optimal reliability during bare-metal deployment and staging, follow this standardized provisioning and management procedure.

---

## 1. Media Preparation & Hardware Initialization

Before initiating any block-level data operations, you must physically prepare the storage media and initialize the file system on the device.

### Step-by-Step Initialization

1. Safely shut down or unplug the USBridge-KVM appliance before modifying any physical hardware components.
2. Insert your storage card into the dedicated onboard MicroSD slot. 
3. Power on the appliance. Using the built-in LCD screen and rotary encoder, navigate to **Settings** -> **SD Card** -> **Format SD**. This process initializes the required Btrfs file-system layout on the card.
4. Navigate to **Settings** -> **SD Card** -> **Snapshot Settings** to define how frequently the system should automatically freeze new read-only data states.
5. After formatting is complete, remain in the **Settings** -> **SD Card** menu and verify that the green **Ready** indicator is displayed at the top of the screen.

---

## 2. Volume Mounting & Data Provisioning

To upload your ISO images, virtual drives, or scripts to the appliance, you must provision access to the KVM's internal storage layer via the client application:

### Step-by-Step Data Upload

1. **Connect to the Appliance:** Launch your native USBridge-Remote client application and ensure your KVM device is actively linked. For first-time deployment, see the [Initial Setup Guide](../1-getting-started/initial-setup.md).
2. **Open Storage Settings:** Click on the **Snapshots** tab in the main application navigation menu.
3. **Mount the Storage:** Locate and click the **Mount Backup Flash** button. 
4. **Access the Drive:** The isolated storage volume will instantly expose itself to your local workstation using hardware emulation. The system will detect it natively as an **MTP Composite Device** without requiring any custom host drivers.
5. **Transfer Your Files:** Open your operating system's file manager, locate the mounted **Main storage** volume, and copy your required deployment images or automation files directly onto this disk.
6. **Automatic Snapshot Generation:** Once your data transfer is complete, you can unmount the drive or simply wait. The underlying Btrfs subsystem will detect the file-system events and automatically freeze your new files into a read-only snapshot layer within 30 seconds (or according to the custom interval defined in your appliance settings).

---

## 3. Snapshot Auditing & Data Recovery

Once a snapshot is generated and appears in the client application interface, you can audit its contents and use it to recover your data states:

### Auditing Snapshot Information
1. Navigate to the **Snapshots** tab in the client interface.
2. Locate your desired snapshot entry and click the **Info (i)** icon.
3. The interface will render a detailed metadata breakdown and structural diff log, explicitly listing all file additions, modifications, and deletions encompassed within that specific snapshot delta.

### Recovering and Extracting Data
1. To return to a previous data state, locate the historical snapshot in the list and click its **Mount** button.
2. The selected snapshot will instantly mount natively on your local workstation as a read-only **MTP device**.
3. Since the mounted snapshot is strictly immutable to ensure data integrity, you can safely browse its directory tree, copy the required historical files or ISO images, and export them back to your main storage or an external drive.


