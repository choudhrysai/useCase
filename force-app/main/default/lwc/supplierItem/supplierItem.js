import { LightningElement, api, wire } from 'lwc';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

export default class SupplierItem extends NavigationMixin(LightningElement) {
    //Api variable to pass the values from parent component
    @api supplierWrapper;
    //to get the page refrence that is used in firing the event
    @wire(CurrentPageReference) pageRef;

    //Handles the onclick event of the button displaying suppliers list
    supplierSelected(event) {
        //Firing the event to show the map marker of the supplier on the map component
        fireEvent(this.pageRef, 'supplierSelected', this.supplierWrapper);
    }

    //Handles the onclick event of the Link displaying the name of the supplier and navigates to record page
    openSupplier() {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.supplierWrapper.supplier.Id,
                objectApiName: 'Supplier__c',
                actionName: 'view'
            }
        });
    }
}