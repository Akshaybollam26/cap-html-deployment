# 🚀 CAPM MTA Fiori Approuter Setup

A complete step-by-step guide to build, configure, and deploy a **CAPM (Cloud Application Programming Model)** project with **Managed Approuter**, **Fiori UI**, **XSUAA**, **HANA**, and **MTA** on **SAP BTP (Cloud Foundry)**.

This repository is ideal for:

* CAPM + Fiori beginners
* SAP BTP developers
* End-to-end MTA-based enterprise app setup

---

## 🧩 Architecture Overview

```
Fiori UI (HTML5 / Fiori App)
        │
        ▼
Managed Approuter (XSUAA Auth)
        │
        ▼
CAP Service (OData v4)
        │
        ▼
SAP HANA Cloud
```

---

## 🛠 Prerequisites

* Node.js ≥ 18
* SAP CDS CLI (`npm install -g @sap/cds-dk`)
* SAP BTP Cloud Foundry Account
* Cloud Foundry CLI
* MBT (MultiApps Build Tool)

---


## 🧱 Step-by-Step Setup

### 1️⃣ Create CAPM Project

```bash
cds init capm-fiori-approuter
cd capm-fiori-approuter
```

---

### 2️⃣ Add HANA & XSUAA

```bash
cds add hana xsuaa
```

📌 This creates:

* `db/` module (HANA)
* `xs-security.json`

---

### 3️⃣ Install Dependencies

```bash
npm install
```

---

### 4️⃣ Add MTA Support

```bash
cds add mta
npm install
```

This generates `mta.yaml`.

---

### 5️⃣ Create Managed Approuter Module

1. Open `mta.yaml`
2. Right click → **Create MTA Module from Template**
3. Select **Approuter**
4. Choose **Managed Approuter**
5. Provide module name (e.g., `approuter`)
6. Select **UI = Yes**
7. ❌ Do **NOT** overwrite `xs-security.json`

📸 *Screenshot Placeholder*: Approuter creation wizard

---

### 6️⃣ Create Fiori Module

1. Open `mta.yaml` again
2. **Create MTA Module from Template**
3. Select **Fiori**
4. Provide a **different module name** (e.g., `app`)
5. ✅ Enable **Add SAP Fiori Launchpad Configuration**

📸 *Screenshot Placeholder*: Fiori module creation

---

### 7️⃣ Update `mta.yaml`

#### 🔹 Update destination-content module

Locate:

```yaml
- name: destination-content
```

Add under `parameters.content.instance.destinations` **before** `existing_destinations_policy`:

```yaml
- Name: srv-api
  Authentication: OAuth2UserTokenExchange
  ServiceInstanceName: <app-name>-auth
  ServiceKeyName: <app>auth-key>
  URL: ~{srv-api/srv-url}
  sap.cloud.service: <manifest.json sap.cloud.service name >
```

---

### 8️⃣ Update `xs-app.json` (Approuter)

📍 File: `approuter/xs-app.json`

Add routing entry:

```json
{
  "source": "^/odata/(.*)$",
  "target": "/odata/$1",
  "authenticationType": "xsuaa",
  "destination": "srv-api",
  "csrfProtection": false
}
```

🔁 Replace `/odata` with your actual CAP service path if needed.

---

## 🚢 Build & Deploy

### Build MTA

```bash
mbt build
```

### Deploy to Cloud Foundry

```bash
cf deploy mta_archives/<project>_1.0.0.mtar
```

---

## ✅ Verification

* Open **SAP BTP Cockpit**
* Navigate to **HTML5 Applications**
* Launch Fiori app via Launchpad
* Verify OData calls go through Approuter
* Check authentication via XSUAA

---

## 🧪 Common Issues & Fixes

| Issue                 | Solution                          |
| --------------------- | --------------------------------- |
| 401 Unauthorized      | Check XSUAA role collections      |
| Destination not found | Verify destination-content module |
| App not visible       | Check HTML5 repo & FLP config     |
| Forbidden             | Wait for a while then data will get previewed| 

---

## 📚 References

* SAP CAP Documentation
* SAP BTP MTA Guide
* Managed Approuter Docs
* SAP Fiori Tools

---

## ⭐ Recommended Enhancements

* Add CAP authorization (`@requires`, `@restrict`)
* Integrate SAP Build Process Automation (BPA)
* Enable Draft Handling
* CI/CD with SAP Continuous Integration

---

## 👤 Author

**Akshay Bollam**
SAP BTP | CAPM | Fiori | BPA

---

If this helped you, ⭐ star the repo and share it with your team!
