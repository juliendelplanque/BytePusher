Class {
	#name : #BPRegister,
	#superclass : #Object,
	#instVars : [
		'name',
		'address'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #'instance creation' }
BPRegister class >> name: name address: address [
	^ self new
		name: name;
		address: address;
		yourself
]

{ #category : #accessing }
BPRegister >> address [
	^ address
]

{ #category : #accessing }
BPRegister >> address: anObject [
	address := anObject asBPAddress
]

{ #category : #converting }
BPRegister >> asBPAddress [
	^ self address
]

{ #category : #accessing }
BPRegister >> name [
	^ name
]

{ #category : #accessing }
BPRegister >> name: anObject [
	name := anObject
]
