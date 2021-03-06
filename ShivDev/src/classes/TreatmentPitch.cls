// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public with sharing class TreatmentPitch{

    public TreatmentPitch(ApexPages.StandardController controller) {
    }


 List<Treatment_Pitch_Information__c> treatpitches = new List<Treatment_Pitch_Information__c>();
 public List<Treatment_Pitch_Information__c> gettpitch()
    { 
     Opportunity Opp = [Select Patient_Name__c,Treatment_Name__c,Treatment_Pitch__c from Opportunity where ID = :ApexPages.CurrentPage().getParameters().get('id')];
     treatpitches = [select Name,Appointment_Name__c, Patient_Name__c, Pitch_Completed__c, Treatment_Number__c, Treatment_Name__c  
     from Treatment_Pitch_Information__c 
     where Patient_Name__c = :Opp.Patient_Name__c And Pitch_Completed__c = False And Treatment_Name__c =:Opp.Treatment_Name__c ];
     //:ApexPages.CurrentPage().getParameters().get('id')     
     return treatpitches;
         }
    
  Public PageReference mySave() {
  Update treatpitches;
  return null;
  }  
      /**************Test Class ***********/
    public static Testmethod void pagrefForClone(){
            Clinic__c clinic= new Clinic__c(Name = 'Ajax');
                insert clinic;
            //creating staff record
            Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=clinic.id);
                insert staff;
            //creating rsource record
            Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=clinic.id);
                insert resource;
            //Creating record for patient
            Contact patient = new Contact(FirstName='', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
                insert patient;
            //creating record for treatment
            Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Treatment', price__c=1000,Resource_Name__c=resource.id);
            insert treatment;
            Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now().addHours(-1), Clinic__c=clinic.id, Name__c = resource.id);
            insert resourceSchedule;
            //Creating appointment record 
            Opportunity opp= new Opportunity(Name='null',CloseDate=system.Today(),clinic__c=clinic.id,
                                                  Treatment_Name__c = treatment.id, Type='Treatment', stageName='Booked',resource__c = resource.id);
            insert opp;      
            ApexPages.StandardController SC = new ApexPages.StandardController(opp);
            ApexPages.currentPage().getParameters().put('id',opp.id);
            TreatmentPitch cont=new TreatmentPitch(SC);
            cont.gettpitch();
            cont.mySave();
      }
}