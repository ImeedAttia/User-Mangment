class Employees {
   String uid;
   String FirstName;
   String LastName;
   String Email;
   String Cin;
   String PhoneNumber;
   String Salaire;
   String Adresse;
   String Status;
   String img;

  Employees(this.uid,this.FirstName, this.LastName, this.Email, this.Cin, this.PhoneNumber,
      this.Salaire, this.Adresse, this.Status,this.img);

  Map<String,dynamic> toJson()=>{
    'uid' :uid,
    'FirstName' :FirstName,
    'LastName' : LastName,
    'Email' : Email,
    'Cin' : Cin,
    'PhoneNumber' : PhoneNumber,
    'Salaire' : Salaire,
    'Adresse' : Adresse,
    'Status' : Status,
    'img' : img,

  };
  static Employees fromJson(Map<String, dynamic> json) => Employees(
      json['uid'],
      json['FirstName'],
      json['LastName'],
      json['Email'],
      json['Cin'],
      json['PhoneNumber'],
      json['Salaire'],
      json['Adresse'],
      json['Status'],
      json['img'],
  );
}