import { notFound } from 'next/navigation'
import { createAnonClient } from '@/utils/supabase/server'
import ClientLayout from './client-layout'

interface LayoutProps {
  children: React.ReactNode
  params: Promise<{
    serviceCode: string
  }>
}

export default async function Layout({ children, params }: LayoutProps) {
  const { serviceCode } = await params
  const supabase = createAnonClient()

  const { data: service } = await supabase
    .from('services')
    .select('name')
    .eq('code', serviceCode)
    .single()

  // If service not found, return 404
  if (!service) {
    notFound()
  }

  return (
    <ClientLayout serviceCode={serviceCode} serviceName={service.name}>
      {children}
    </ClientLayout>
  )
}
