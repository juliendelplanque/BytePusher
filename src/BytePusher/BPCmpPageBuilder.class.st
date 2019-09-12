Class {
	#name : #BPCmpPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPCmpPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #CMP_PAGE;
		yourself
]

{ #category : #accessing }
BPCmpPageBuilder class >> startAddress [
	^ 16r30000 asBPAddress
]

{ #category : #writing }
BPCmpPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (x = y ifTrue: [ TRUE_VALUE ] ifFalse: [ FALSE_VALUE ]) ]
]
