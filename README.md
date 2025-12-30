CAPM MTA Fiori Approuter Setup

1 Create CAPM project  
cds init <app>  
cd <app>  

2 Add hana and xsuaa  
cds add hana xsuaa  

3 Install dependencies  
npm install  

4 Add mta  
cds add mta  
npm install  

5 Create approuter module  
Open mta.yaml  
Right click and choose Create MTA module from template  
Select Approuter  
Choose Managed Approuter  
Provide name and select UI option Yes  
Do not overwrite xs-security.json  

6 Create fiori module  
Open mta.yaml again  
Choose Create MTA module from template  
Select Fiori  
Provide a different module name  
Enable Add SAP Fiori Launchpad Configuration  

7 Update mta.yaml  

Find module  
- name: <app>-destination-content  

Add above parameters  
- name: srv-api  

Under parameters content instance destinations add before existing_destinations_policy  

- Name: srv-api  
  Authentication: OAuth2UserTokenExchange  
  ServiceInstanceName: <app>-auth  
  ServiceKeyName: <app>-auth-key  
  URL: ~{srv-api/srv-url}  
  sap.cloud.service: <app>  

8 Update xs-app.json in approuter  

Add routing entry  

{  
  "source": "^/<service URL>/(.*)$",  
  "target": "/<service URL>/$1",  
  "authenticationType": "xsuaa",  
  "destination": "srv-api",  
  "csrfProtection": false  
}  

Replace <service URL> with your service path  

9 Build and deploy  

mbt build  
cf deploy mta_archives/<app>_1.0.0.mtar  
