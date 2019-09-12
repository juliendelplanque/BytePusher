Class {
	#name : #BPIdentityPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

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

{ #category : #writing }
BPIdentityPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		|x|
		x := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: x ]
]
