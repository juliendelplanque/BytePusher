Class {
	#name : #BPVirtualMachineAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'virtualMachine'
	],
	#category : #'BytePusher-VM-Debugging'
}

{ #category : #accessing }
BPVirtualMachineAnnouncement >> virtualMachine [
	^ virtualMachine
]

{ #category : #accessing }
BPVirtualMachineAnnouncement >> virtualMachine: anObject [
	virtualMachine := anObject
]
