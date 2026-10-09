 
#!/bin/bash

symmetric_encrypt() {

echo "= Symmetric Encryption ="

	read -p "Enter the file to encrypt: " input_file

if [ ! -f "$input_file" ]; then
	echo "Error: File does not exist."
	return
fi

	read -p "Enter the file for the encrypted file: " output_file

	if openssl enc -aes-256-cbc -pbkdf2 -iter 1000 -in "$input_file" -out "$output_file"; then

	echo "Encryption successful."
	echo "Encrypted file: $output_file"
else
	echo "Encryption failed."
fi

}



symmetric_decrypt() {

echo "= Symmetric Decryption ="

        read -p "Enter the file to decrypt: " input_file

if [ ! -f "$input_file" ]; then
        echo "Error: File does not exist."
        return
fi

        read -p "Enter the file for the decrypted file: " output_file

        if openssl enc -d -aes-256-cbc -pbkdf2 -iter 1000 -in "$input_file" -out "$output_file"; then

        echo "Decryption successful."
        echo "Decrypted file: $output_file"
else
        echo "Decryption failed."
fi

}


generate_keys() {
    echo "== GENERATE PUBLIC/PRIVATE KEYS =="

    read -p "Enter the name for the private key: " private_key
    read -p "Enter the name for the public key: " public_key

    if [ -e "$private_key" ]; then
        echo "Error: Private key file already exists."
        return
    fi

    if [ -e "$public_key" ]; then
        echo "Error: Public key file already exists."
        return
    fi

    openssl genrsa -out "$private_key" 2048

    if [ $? -ne 0 ]; then
        echo "Error: Private key generation failed."
        return
    fi

    openssl rsa -in "$private_key" -pubout -out "$public_key"

    if [ $? -eq 0 ]; then
        echo "Keys generated successfully."
        echo "Private key: $private_key"
        echo "Public key: $public_key"
    else
        echo "Error: Public key generation failed."
    fi
}


asymmetric_encrypt() {
    echo "========== ASYMMETRIC ENCRYPTION =========="

    read -p "Enter the file to encrypt: " input_file

    if [ ! -f "$input_file" ]; then
        echo "Error: File does not exist."
        return
    fi

    read -p "Enter the name for the encrypted file: " output_file

    if [ -f "$output_file" ]; then
        echo "Error: Output file already exists."
        return
    fi

    if [ ! -f "public.pem" ]; then
        echo "Error: public.pem does not exist."
        echo "Please generate the keys using Option 3."
        return
    fi

    openssl pkeyutl -encrypt -pubin -inkey public.pem -in "$input_file" -out "$output_file"

    if [ $? -eq 0 ]; then
        echo "Asymmetric encryption successful."
        echo "Encrypted file: $output_file"
    else
        echo "Asymmetric encryption failed."
    fi
}



asymmetric_decrypt() {
    echo "====== ASYMMETRIC DECRYPTION ======"

    read -p "Enter the encrypted file: " input_file

    if [ ! -f "$input_file" ]; then
        echo "Error: Encrypted  file does not exist."
        return
    fi

    read -p "Enter the name for the decrypted file: " output_file

    if [ -f "$output_file" ]; then
        echo "Error: Encrypted fie does not exist"
        return
    fi

    if [ ! -f "private.pem" ]; then
        echo "Error: private.pem does not exist."
        echo "Please generate the keys using Option 3."
        return
    fi

    openssl pkeyutl -decrypt -inkey private.pem -in "$input_file" -out "$output_file"

    if [ $? -eq 0 ]; then
        echo "Asymmetric decryption successful."
        echo "Decrypted file: $output_file"
    else
        echo "Asymmetric decryption failed."
    fi
}

hash_file() {
    echo "========== HASH A FILE =========="

    read -p "Enter the file to hash: " input_file

    if [ ! -f "$input_file" ]; then
        echo "Error: File does not exist."
        return
    fi

    echo "Choose a hashing algorithm:"
    echo "1. SHA-256"
    echo "2. SHA-512"

    read -p "Choose an option: " hash_choice

    if [ "$hash_choice" = "1" ]; then
        sha256sum "$input_file"

    elif [ "$hash_choice" = "2" ]; then
        sha512sum "$input_file"

    else
        echo "Error: Invalid hashing option."
    fi
}

generate_signature() {
    echo "== GENERATE DIGITAL SIGNATURE =="

    read -p "Enter the file to sign: " input_file

    if [ ! -f "$input_file" ]; then
        echo "Error: File does not exist."
        return
    fi

    if [ ! -f "private.pem" ]; then
        echo "Error: private.pem does not exist."
        echo "Please generate the keys using Option 3."
        return
    fi

    read -p "Enter the name for the signature file: " signature_file

    if [ -f "$signature_file" ]; then
        echo "Error: Signature file already exists."
        return
    fi

    openssl dgst -sha256 -sign private.pem -out "$signature_file" "$input_file"

    if [ $? -eq 0 ]; then
        echo "Digital signature generated successfully."
        echo "Signature file: $signature_file"
    else
        echo "Digital signature generation failed."
    fi
}

verify_signature() {
    echo "=== VERIFY DIGITAL SIGNATURE =========="

    read -p "Enter the original file: " input_file

    if [ ! -f "$input_file" ]; then
        echo "Error: Original file does not exist."
        return
    fi

    read -p "Enter the signature file: " signature_file

    if [ ! -f "$signature_file" ]; then
        echo "Error: Signature file does not exist."
        return
    fi

    if [ ! -f "public.pem" ]; then
        echo "Error: public.pem does not exist."
        echo "Please generate the keys using Option 3."
        return
    fi

    openssl dgst -sha256 -verify public.pem -signature "$signature_file" "$input_file"

    if [ $? -eq 0 ]; then
        echo "Signature verification completed."
    else
        echo "Signature verification failed."
    fi
}


while true
do

echo "================================"
echo "   CRYPTOGRAPHY TOOLKT"
echo "==========================="
echo "1. Symmetric Encryption"
echo "2. Symmetric Decryption"
echo "3. Generate RSA Keys"
echo "4. Asymmetric Encryption"
echo "5. Asymmetric Decryption"
echo "6. Hash a File"
echo "7. Digital Signature"
echo "8. Verify Signature"
echo "9. Exit"
echo "============================="
echo "Thank You!"


read -p "Choose an option: " choice

if [ "$choice" = "1" ]; then
	symmetric_encrypt
fi

if [ "$choice" = "2" ]; then
    symmetric_decrypt
fi

if [ "$choice" = "3" ]; then
    generate_keys
fi

if [ "$choice" = "4" ]; then
    asymmetric_encrypt
fi

if [ "$choice" = "5" ]; then
    asymmetric_decrypt
fi

if [ "$choice" = "6" ]; then
    hash_file
fi

if [ "$choice" = "7" ]; then
    generate_signature
fi

if [ "$choice" = "8" ]; then
    verify_signature
fi


if [ "$choice" = "9" ]; then
          echo "Exiting Crypto Toolkit..."

	exit
fi
done
