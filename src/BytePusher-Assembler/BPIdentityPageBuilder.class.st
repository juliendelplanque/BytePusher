Class {
	#name : #BPIdentityPageBuilder,
	#superclass : #BPPageInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPIdentityPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #IDENTITY_PAGE;
		yourself
]

{ #category : #generating }
BPIdentityPageBuilder >> byteForAddress: anInteger [
	^ anInteger & 16rFF
]
