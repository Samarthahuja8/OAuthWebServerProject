import { LightningElement,wire,api } from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import getAccessToken from '@salesforce/apex/MakeCalloutOAuth.getAccessToken';
import createAccount from '@salesforce/apex/MakeCalloutOAuth.createAccount';

export default class OAuthFlowComponent extends NavigationMixin(LightningElement) {
    authURL = 'https://YOUR_MY_DOMAIN.my.salesforce.com/services/oauth2/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URL&response_type=code'

    currentPageReference = null; 
    urlStateParameters = null;
    showAuth = true
    accessToken = false
    showError = false
    errorMessage
    createdAccount = false
    
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          console.log(this.urlStateParameters)
          if (this.urlStateParameters.code) {
            this.showAuth = false
          }
       }
    }

    get showAccessToken() {
        return (this.accessToken).substring(0,18)
    }
    handleClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.authURL
            }
        },
        true // Replaces the current page in your browser history with the URL
        );
    }

    handleClickAccess() {
        getAccessToken({ authCode: this.urlStateParameters.code })
        .then(result => {
            console.log(result)
            const obj = JSON.parse(result)
            if(obj.hasOwnProperty('error')) {
                this.showError = obj['error']
                this.errorMessage = obj['error_description']
                return
            }
            this.accessToken = obj['access_token']
            console.log(this.accessToken)
        })
        .catch(error => {
            console.error(error)
        });

    }
    handleAccountCreation() {
        var inputCmp = this.template.querySelector('.inputCmp');
        var value = inputCmp.value;
        console.log('value',value)
        if(value=='' || value==undefined || value==null) {
            inputCmp.reportValidity();
            return
        }

        createAccount({accessToken:this.accessToken,accName:value}).then(result=>{
            console.log(result)
            const obj = JSON.parse(result)
            this.createdAccount = obj['id']
        }).catch(error=>{
            console.error(error)
        })

    }
}