Class {
	#name : #BPAnnouncingVirtualMachine,
	#superclass : #BPVirtualMachine,
	#instVars : [
		'announcer'
	],
	#category : #'BytePusher-VM-Debugging'
}

{ #category : #announce }
BPAnnouncingVirtualMachine >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #accessing }
BPAnnouncingVirtualMachine >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
BPAnnouncingVirtualMachine >> announcer: anObject [
	announcer := anObject
]

{ #category : #running }
BPAnnouncingVirtualMachine >> innerStep [
	self announce: (BPAboutToExecute vm: self pc: self programCounter).
	^ super innerStep
]
