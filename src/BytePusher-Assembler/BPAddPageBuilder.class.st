Class {
	#name : #BPAddPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPAddPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_PAGE;
		yourself
]

{ #category : #writing }
BPAddPageBuilder class >> startAddress [
	^ 16r10000 asBPAddress
]

{ #category : #writing }
BPAddPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (x + y) % 16rFF	 ]
]
