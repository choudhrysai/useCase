import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

const FIELDS = [
    'Account.Name',
    'Account.BillingCity',
    'Account.BillingLatitude',
    'Account.BillingLongitude',
    'Account.BillingStreet',
    'Account.BillingPostalCode',
    'Account.BillingState',
    'Account.BillingCountry'
];


export default class SupplierMap extends LightningElement {
    //Api Variables
    @api recordId;

    account;

    //To handle errors and display the erro message
    @track errorMessage;

    //Track variables to add markers to map 
    @track accountLocation;
    @track supplierLocation;

    @track selectedMarkerValue = "";//To display the selected location from list
    @track mapMarkers = []; // The list holding the map markers
    @track mapZoomLevel = "15"; // Zoom level of the map initially set to street level

    //Wire Methods to retrieve the accpunt details and map marker of  account address
    @wire(CurrentPageReference) pageRef;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredData({ err, data }) {
        if (data) {
            this.account = data;
            this.errorMessage = undefined;
            this.addAccountToMarker();
        } else if (err) {
            console.error(err);
            this.errorMessage = "Something went wrong, Please try again";
            if (Array.isArray(err.body)) {
                this.errorMessage = this.errorMessage + " " + err.body.map(e => e.message).join(', ');
            } else if (typeof err.body.message === 'string') {
                this.errorMessage = this.errorMessage + " " + error.body.message;
            }
            this.account = undefined;
        }
    }

    //Invoked when  onnected
    connectedCallback() {
        //Registers the listener for the event supplierSelected 
        registerListener('supplierSelected', this.handleSupplierSelected, this);
    }
    //invoked when disconnected
    disconnectedCallback() {
        //un-registering the listerners
        unregisterAllListeners(this);
    }
    //Executed when an supplierSelected is received and adds the supplier marker to Map
    handleSupplierSelected(supplierDetails) {
        if (supplierDetails) {
            this.supplierLocation = {
                value: supplierDetails.supplier.Name,
                location: {
                },
                icon: 'custom:custom31',
                title: supplierDetails.supplier.Name
            };
            this.supplierLocation.location = {
                Latitude: supplierDetails.supplier.Location__Latitude__s,
                Longitude: supplierDetails.supplier.Location__Longitude__s,
                City: supplierDetails.supplier.City__c,
                Country: supplierDetails.supplier.Country__c,
                PostalCode: supplierDetails.supplier.PostalCode__c,
                State: supplierDetails.supplier.State__c,
                Street: supplierDetails.supplier.Street__c
            }
            this.mapZoomLevel = "10";
            this.mapMarkers = [];
            this.mapMarkers.push(this.accountLocation);
            this.mapMarkers.push(this.supplierLocation);
        }
    }
    //Adds the Account location as map marker 
    addAccountToMarker() {
        if (this.account) {
            this.accountLocation = {
                value: this.account.fields.Name.value,
                location: {
                },
                icon: 'standard:avatar',
                title: this.account.fields.Name.value
            };
            this.selectedMarkerValue = this.account.fields.Name.value;
            this.accountLocation.location = {
                Latitude: this.account.fields.BillingLatitude.value,
                Longitude: this.account.fields.BillingLongitude.value,
                City: this.account.fields.BillingCity.value,
                Country: this.account.fields.BillingCountry.value,
                PostalCode: this.account.fields.BillingPostalCode.value,
                State: this.account.fields.BillingState.value,
                Street: this.account.fields.BillingStreet.value
            }
            this.mapMarkers = [];
            this.mapMarkers.push(this.accountLocation);
        }
    }
    //Handles the clcik event of Locations displayed on the Map
    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.detail.selectedMarkerValue;
    }
}