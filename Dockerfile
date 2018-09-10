FROM debian:latest AS builder

RUN echo "Updating and installing dependancies of build container" &&\
  DEBIAN_FRONTEND=noninteractive apt-get update &&\
#  DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential \
  devscripts \
  debhelper \
  cdbs \
  autotools-dev \
  dh-buildinfo \
  libdb-dev \
  libwrap0-dev \
  libpam0g-dev \
  libcups2-dev \
  libkrb5-dev \
  libltdl3-dev \
  libgcrypt11-dev \
  libcrack2-dev \
  libavahi-client-dev \
  libldap2-dev \
  libacl1-dev \
  libevent-dev \
  d-shlibs \
  dh-systemd \
  git \
  figlet &&\
  echo "Cloning netalk repo" &&\
  echo "https://techsmix.net/timemachine-backups-debian-8-jessi/" &&\
  git clone  https://github.com/adiknoth/netatalk-debian &&\
  cd netatalk-debian &&\
  figlet "Compiling" &&\
  cat << "EOF"
                              `.                                       
                            #:   @                                     
                           @      @                                    
                           .                                           
                          `        .     :.                            
                           `       `      .@   :                       
                           #      '       @ @ ,:+           ##+@       
                           +      @        @ ;', :`        #    @      
                            '    +        + ' :#`@        '      @     
                            `@.,@           `@@ # ,      @       :     
                             @             ; +`+``#      #       '     
                           #, +#           :`+ @,        ;       @     
                         #, @   +:        # @'  @:`      +      ``     
                    .@+:,  `      #;   ; ',. #   @.@'    @      @      
                   ,       @        +' @@'        @#@    `;    @       
                           :          @@@@        #@@:     @@@:        
                          `          #.;            +;''               
             +            #                             `'++@@.        
             `@           +,                     ;+       ;#           
             ``          + @                     ,@@::@@+,   .         
         :  '@ @         ,  +               @    . @         #         
         + `:@ :        @   '               @   +. '         @         
         @  :@  '      `     @              +  '@: .  @'+;` ``         
         @  @@; @      #     @              '  `++  ` +    ,@          
     ;   @    # :     @     .           @   ;   #@  : `   #`           
     @   @    @#`           @           ,   :    @  '  .:@             
 ,   '   +    ;,::   #     ,         `  `   +    @' : .@               
 ,   ,   :     ;    @;#@',`@            ,   @    @@:   @;              
 `   :   `     @  @`        +           +   ,    `     @;'@;           
 ,   '         # ,          @        `  '         #   ,@@@@@@,         
 ;   #    `    `  @@#.` .'@;                 +    @ :'        `        
 ;   :    '     +;;';+@@#:               ;   @    @ @        '         
      `   @             @                :        ,  #@@+#@@#          
      :.  :          `  :   ..,,,.        ;   '    '@@@@@@@@.          
#####@@@++#';,.`     +   .          .:;:,.    +      `.,@ .`..,:'++@+++
           #         @   @                     +        ;  '           
           .         ,   +                             @   +           
            ;       @     ;                            ,    @          
            `      : .+@@@+                           @,@+'#@@         
               `#  @'     ,@`,                     + ;# `,:#@@@  .@    
               ,` '@`    ` @ ;                   @+ .@#;     @'  #`    
                  @#       @ .                   .. @#       `:  '     
                                                    ,`                 
EOF &&\
  debuild -b -uc -us &&\
  ls -alh &&\
  figlet "Starting Build"


FROM debian:stable-slim

COPY --from=builder /libatalk*_*-1_amd64.deb /installfiles/
COPY --from=builder /netatalk_*-1_amd64.deb /installfiles/
COPY --from=builder /libatalk18-dbgsym_*-1_amd64.deb /installfiles/

RUN DEBIAN_FRONTEND=noninteractive apt-get update &&\
#  DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y install dumb-init \
  libwrap0 \
  libldap-common \
  libcrack2 \
  avahi-daemon \
  libavahi-client3 \
  libldap-common \
  slapd \
  libevent-dev \
  python &&\
  cd /installfiles/ &&\
  dpkg -i libatalk18_3.*-1_amd64.deb netatalk_*-1_amd64.deb &&\
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

# Runs "/usr/bin/dumb-init -- /my/script --with --args"
#ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# or if you use --rewrite or other cli flags
# ENTRYPOINT ["dumb-init", "--rewrite", "2:3", "--"]

#CMD ["/my/script", "--with", "--args"]