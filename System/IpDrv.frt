[Public]
Object=(Name=IpDrv.UpdateServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.MasterServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.CompressCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.DecompressCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.TcpNetDriver,Class=Class,MetaClass=Engine.NetDriver)
Object=(Name=IpDrv.UdpBeacon,Class=Class,MetaClass=Engine.Actor)
Preferences=(Caption="R�seau",Parent="Options avanc�es")
Preferences=(Caption="Jeu en r�seau TCP/IP",Parent="R�seau",Class=IpDrv.TcpNetDriver)
Preferences=(Caption="Balise serveur",Parent="R�seau",Class=IpDrv.UdpBeacon,Immediate=True)

[TcpNetDriver]
ClassCaption=Jeu en r�seau TCP/IP

[UdpBeacon]
ClassCaption=Balise serveur LAN

[CompressCommandlet]
HelpCmd=compression
HelpOneLiner=Compresser un package Unreal pour le t�l�chargement automatique. Un fichier .uz sera cr��.
HelpUsage=compression Fichier1 [Fichier2 [Fichier3 ...]]
HelpParm[0]=Fichiers
HelpDesc[0]=Noms de fichiers � compresser.

[DecompressCommandlet]
HelpCmd=d�compresser
HelpOneLiner=D�compresser un fichier compress� avec ucc.
HelpUsage=D�compresser un fichier compress�
HelpParm[0]=Fichier compress�
HelpDesc[0]=Le fichier .uz � d�compresser

[MasterServerUplink]
MSUPropText[0]="Annoncer serveur"
MSUPropText[1]="Traitement stats"
MSUPropDesc[0]="Si activ�, votre serveur sera affich� sur le navigateur de serveurs Internet"
MSUPropDesc[1]="Publie les stats des joueurs de votre serveur sur le site web de Red Orchestra."

