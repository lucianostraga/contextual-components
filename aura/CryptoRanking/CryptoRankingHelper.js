({
    getCryptos : function(component, event, helper){
		
        component.set('v.Coin_List', []);	
        component.set('v.isLoading', true);    
        
        var action;
        
        console.log('#### SOBJ: '+component.get("v.sObjectName"));
        console.log('#### SOBJID: '+component.get("v.recordId"));
        
        if(component.get("v.recordId")!= null && component.get("v.sObjectName") == 'Opportunity'){
            console.log('#### IS AN OPPORTUNITY');
            
            action = component.get("c.getCryptosByOppId");
            action.setParams({
                opportunityId : component.get("v.recordId") 
            });
            
        }else{
            action = component.get("c.getCryptos");
        }

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(component.isValid() && state === "SUCCESS") {                
                console.log(response.getReturnValue());
                component.set('v.Coin_List', response.getReturnValue());
            } else {
                
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
            
            component.set('v.isLoading', false);
        });
        $A.enqueueAction(action);     
    },
})