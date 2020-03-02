Class {
	#name : #BPAboutToExecute,
	#superclass : #BPVirtualMachineAnnouncement,
	#instVars : [
		'programCounter'
	],
	#category : #'BytePusher-VM-Debugging'
}

{ #category : #'instance creation' }
BPAboutToExecute class >> vm: aVirtualMachine pc: programCounterValue [
	^ self new
		virtualMachine: aVirtualMachine;
		programCounter: programCounterValue;
		yourself
]

{ #category : #printing }
BPAboutToExecute >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '(pc='.
	self programCounter printOn: aStream base: 16.
	aStream nextPut: $)
]

{ #category : #accessing }
BPAboutToExecute >> programCounter [
	^ programCounter
]

{ #category : #accessing }
BPAboutToExecute >> programCounter: anObject [
	programCounter := anObject
]
