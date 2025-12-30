using {cap.db} from '../db/schema';
 
service MyService @(requires: 'authenticated-user') {
   
    @restrict:[
        { grant: '*', to : 'capAdmin'},
        {grant: 'READ', to: 'capEmp'}
    ]
    entity Books as projection on db.Books;
 
}
