# Déploiement d'une Infrastructure Azure

Ce projet utilise Terraform pour déployer une infrastructure cloud sur Microsoft Azure. L'objectif est de créer un environnement réseau complet et un cluster Kubernetes prêt à l'emploi. Voici les composants principaux et leur rôle :

## 1. Structure du Projet

Le projet est organisé en plusieurs fichiers Terraform, chacun ayant un rôle précis :

### a. Fichiers principaux :

- main.tf : Définit les ressources Azure principales et appelle un module pour gérer la configuration réseau.
- providers.tf : Configure Terraform pour utiliser le fournisseur Azure (azurerm) et spécifie la version.
- terraform.tfvars : Contient les valeurs des variables pour personnaliser le déploiement (groupe de ressources, localisation, noms, etc.).
- variables.tf : Définit les variables utilisées dans le projet et leurs descriptions.
- outputs.tf : Fournit les résultats des ressources déployées, comme le nom et la localisation du groupe de ressources.

### b. Module réseau :

Le module gère la création des éléments réseau, tels que :
- Groupe de ressources.
- Réseau virtuel (VNet).
- Sous-réseaux (subnets).
- Passerelle d'application (Application Gateway).
- Interface réseau (NIC).
- Sécurité réseau (NSG).
- NAT Gateway pour la gestion des IP publiques.

## 2. Fonctionnalités Principales

### a. Réseau :

Création d'un réseau virtuel (VNet) avec des sous-réseaux dédiés :
- Un sous-réseau pour les applications.
- Un sous-réseau pour la passerelle d'application.
Passerelle NAT (NAT Gateway) :
- Associe une IP publique pour gérer le trafic sortant.
Sécurité réseau (NSG) :
- Règles pour autoriser le trafic HTTP entrant (port 80).

### b. Passerelle d'Application (Application Gateway) :

- Permet de gérer le routage du trafic HTTP.
- Comprend des configurations pour le frontend (IP publique) et le backend (applications connectées via des NIC).

### c. Cluster Kubernetes (AKS) :

Déploiement d’un cluster Kubernetes géré par Azure (AKS) :
- Un pool de nœuds par défaut (VM Standard_A2_v2).
- Identité managée pour les ressources du cluster.
- Prêt pour déployer des conteneurs et applications.

## 3. Prérequis

Logiciels nécessaires :
- Terraform (version ≥ 1.0).
- Azure CLI pour se connecter à votre compte Azure.
Compte Azure avec les permissions nécessaires pour créer des ressources. <br/>

Configuration initiale :
- Connectez-vous à Azure avec az login.
- Configurez un backend distant (optionnel) pour stocker l’état Terraform.

## 4. Instructions

Cloner le projet :

```clone
git clone <URL du projet>
cd <dossier du projet>
```

Initialiser Terraform :
- Téléchargez les dépendances du fournisseur :
```code
terraform init
```

Planifier le déploiement :
- Prévisualisez les ressources qui seront créées :
```code
terraform plan -var-file="terraform.tfvars"
```

Appliquer le déploiement :
- Créez les ressources sur Azure :
```code
terraform apply -var-file="terraform.tfvars"
```
- Tapez yes pour confirmer.

Afficher les sorties :
- Une fois le déploiement terminé, les informations clés (nom du groupe de ressources, localisation) s'afficheront.

## 5. Structure du Réseau

Le réseau est conçu pour être modulaire et sécurisé :

- Réseau virtuel (VNet) : Espace d’adressage IP structuré pour les sous-réseaux.
- Sous-réseaux :
    - Application Subnet : Pour héberger des interfaces réseau et gérer le trafic des applications.
    - Gateway Subnet : Réservé à la passerelle d’application.
- Passerelle d'Application : Permet un routage HTTP vers les ressources backend.

## 6. Personnalisation

Les variables dans terraform.tfvars peuvent être ajustées pour répondre à vos besoins :
- Localisation des ressources (ex. westeurope).
- Noms des ressources (ex. cluster AKS, passerelle NAT).
- Adressage IP (plages pour le réseau virtuel et les sous-réseaux).

## 7. Nettoyage

Pour supprimer les ressources, exécutez :
```code
terraform destroy -var-file="terraform.tfvars"
```
Validez avec yes.

## 8. Limitations et Améliorations

- Limites actuelles :
    - Le cluster AKS utilise une configuration minimale (1 nœud).
    - Les configurations avancées (certificats SSL pour l’Application Gateway, scaling) ne sont pas implémentées.
- Améliorations possibles :
    - Ajouter des règles NSG plus détaillées.
    - Configurer l’Application Gateway pour HTTPS.
        Automatiser le déploiement d’applications sur AKS.
