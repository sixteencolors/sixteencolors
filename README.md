# Sixteen Colors

A perl-based application to run the Sixteen Colors Art Pack Archive.

## Database Schema

![Database Schema](etc/schema.png)

## [*In Progress*] Installation (Ubuntu)

### Notes

* These steps assume a fresh, bare-bones install of Ubuntu 14.04.
* Everything will be deployed to `/var/www/sixteencolors.net/`.
* The site will be served via nginx to a reverse proxied plack-based listener.

### Steps

1. Install required packages.

    ```
    sudo apt-get install build-essential nginx
    ```

2. Create deployment directory.

    ```
    sudo mkdir /var/www/sixteencolors.net/
    ```

3. Install perlbrew.

    ```
    wget -O - http://install.perlbrew.pl | sudo PERLBREW_ROOT=/var/www/sixteencolors.net/perl5 bash
    echo 'source /var/www/sixteencolors.net/perl5/etc/bashrc' >> ~/.bash_profile
    ```

4. Install perl.

    ```
    perlbrew install --notest --switch stable   
    ```

5. Install cpanm.

    ```
    perlbrew install-cpanm
    ```

6. Clone the application repository. *NB:* Using `code-refresh` branch.

    ```
    cd /var/www/sixteencolors.net/ && git clone -b code-refresh https://github.com/sixteencolors/sixteencolors.git app
    ```
7. Install perl dependencies

    ```
    cd /var/www/sixteencolors.net/app/ && cpanm --notest --installdeps .
    ```
