Class {
	#name : #BPIdentityPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPIdentityPageBuilder class >> bankSize [
	^ 16rFF
]

{ #category : #accessing }
BPIdentityPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #IDENTITY_PAGE;
		yourself
]

{ #category : #accessing }
BPIdentityPageBuilder class >> startAddress [
	^ 16r40000 asBPAddress
]

{ #category : #generating }
BPIdentityPageBuilder >> byteForAddress: anInteger [
	^ anInteger & 16rFF
]
