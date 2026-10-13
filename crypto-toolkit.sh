

#!/bin/bash

while true
do

 echo "================================"
 echo "      CRYPTOGRAPHY TOOLKIT"
 echo "================================"
  echo "1. Create a File"
  echo "2. Symmetric Encryption"
  echo "3. Symmetric Decryption"
  echo "4. Generate RSA Keys"
  echo "5. Asymmetric Encryption"
  echo "6. Asymmetric Decryption"
  echo "7. Hash a File"
  echo "8. Generate Digital Signature"
  echo "9. Verify Digital Signature"
  echo "10. Exit"
  echo "================================"

    read -p "Choose an option: " choice


  if [ "$choice" = "1" ]; then
	echo "-----CREATE A FILE-----"

  read -p "Enter file name: " file_name
	if [ -f "$file_name" ]; then
	echo "Erro File already exists"
  else
	touch "$file_name"
	if [ -f "$file_name" ]; then
	echo "file created"
  else
	echo "file creation failed"
  fi
  fi

 elif [ "$choice" = "2" ]; then

	echo "-----Symmetric Encryption--------"
	read -p "Enter the file to encrypt: " input_file

	if [ -f "$input_file" ]; then

        read -p "Enter the name for encrypted file: " output_file

 	if [ -f "$output_file" ]; then
	echo "Error: Output file already exists."

	else
    if  openssl enc  -aes-256-cbc -pbkdf2 -iter 1000 -in "$input_file"  -out "$output_file"; then

	echo "Encryption seccessful."
	echo "Encryption file: $output_file"
  else
	echo "Encryption failed"
  fi
fi
else
echo "Error: Input file does not exist."
fi


elif [ "$choice" = "3" ]; then

        echo "-----Symmetric Decryption--------"
        read -p "Enter the encrypted file: " input_file

        if [ -f "$input_file" ]; then

        read -p "Enter the name for decrypted file: " output_file

        if [ -f "$output_file" ]; then
        echo "Error: Output file already exists."

        else
    if  openssl enc -d  -aes-256-cbc -pbkdf2 -iter 1000 -in "$input_file"  -out "$output_file"; then

        echo "Decryption seccessful."
        echo "Decryption file: $output_file"
  else
        echo "Decryption failed"
  fi
fi
else
 echo "Error: Encrypted file does not exist."
fi


elif [ "$choice" = "4" ]; then

        echo "-----Generate RSA Keys--------"
        read -p "Enter name for private key: " private_key
	read -p "Enter name for public  key: " public_key


        if [ -f "$private_key" ]; then
	echo "Error: Private key file already exists"

	elif [ -f "$public_key" ]; then
	echo "Erro: Public key file already exists"

	else 
	if openssl genrsa -out "$private_key" 2048; then
	  
         echo "Private key generated successfully."
	
	if openssl rsa -in "$private_key" -pubout -out "$public_key"; then
	echo "public key successfully generated."
	echo "private_key: $private_key"
	echo "public_key: $public_key"
   else
	echo "Error: public key generation failed."
   fi


   else 
    echo "Error: Private key generation failed"
 fi
fi


elif [ "$choice" = "5" ]; then

        echo "-----Assymmetric Encryption--------"
        read -p "Enter the file to encrypt: " input_file

        if [ -f "$input_file" ]; then
	
	read -p "Enter the public key file: " public_key

	if [ -f "$public_key" ]; then
	
	read -p "Enter the name for the encrypted file: " output_file

	if [ -f "$output_file" ]; then
          echo "Error: Output file already exists."
	else


      if openssl pkeyutl -encrypt -pubin -inkey "$public_key" -in "$input_file" -out "$output_file"; then


        echo "Encryption successful."
        echo "Encrypted file: $output_file"
  else
        echo "Encryption failed"
  fi
fi
else
	echo "Error: public key file does not exist."

fi

 else
    echo "Error: Input file does not exist."
fi


elif [ "$choice" = "6" ]; then

        echo "-----Assymmetric Decryption--------"
        read -p "Enter the file to decrypt: " input_file

        if [ -f "$input_file" ]; then
        
        read -p "Enter the private key file: " private_key

        if [ -f "$private_key" ]; then
        
        read -p "Enter the name for the decrypted file: " output_file

        if [ -f "$output_file" ]; then
          echo "Error: Output file already exists."
        else


      if openssl pkeyutl -decrypt  -inkey "$private_key" -in "$input_file" -out "$output_file"; then


        echo "Decryption successful."
        echo "Decrypted file: $output_file"
  else
        echo "Decryption failed"
  fi
fi
else
        echo "Error: private key file does not exist."

fi

 else
    echo "Error: Encrypted does not exist."
fi


elif [ "$choice" = "7" ]; then

        echo "-----Hash A File--------"
        read -p "Enter the file to hash: " input_file

        if [ -f "$input_file" ]; then

	echo "1. SHA-256"
        echo "2. SHA-512"
	read -p "Choose a hashing algorithm: " hash_choice

	if [ "$hash_choice" = "1" ]; then
            sha256sum "$input_file"

	elif [ "$hash_choice" = "2" ]; then
            sha512sum "$input_file"
	else
	  echo "Error: Invalid hashing option"
	fi
	
	else
	 echo "Error: File does not exist"
	fi

elif [ "$choice" = "8" ]; then

        echo "-----Digital Signature--------"
        read -p "Enter the file to sign: " input_file

        if [ -f "$input_file" ]; then
        
        read -p "Enter the private key file: " private_key

        if [ -f "$private_key" ]; then
        
        read -p "Enter the name for the signature file: " signature_file

        if [ -f "$signature_file" ]; then
          echo "Error: signature file already exists."
        else
	if openssl dgst -sha256 -sign "$private_key" -out "$signature_file" "$input_file"; then
               

 echo "Digital signature created successfully."
        echo "Signature file: $signature_file"
          else
         echo "Digital signature creation failed."
     fi
    fi
	else 
	echo "error: Private key file does not exist."
	fi
	else
	echo "Error: file to sign does not exists"
	fi


elif [ "$choice" = "9" ]; then

        echo "-----Verify Signature--------"
        read -p "Enter the original file: " input_file

        if [ -f "$input_file" ]; then
        
        read -p "Enter the signature file: " signature_file

        if [ -f "$signature_file" ]; then
        
        read -p "Enter the public key file: " public_key

        if [ -f "$public_key" ]; then
	
	
        if  openssl dgst -sha256 -verify "$public_key" -signature "$signature_file" "$input_file"; then
	
               
        echo "signature verify  successfully."
          else
         echo "signature verification failed."
    fi
        else 
        echo "error: Public key file does not exist."
        fi
        else
        echo "Error: signature file does not exist"
        fi
fi



  elif [ "$choice" = "10" ]; then
  echo "Thank you! You just exit cryptography toolkit." 
	 exit
  fi
done









