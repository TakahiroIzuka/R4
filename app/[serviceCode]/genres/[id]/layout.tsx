import { createClient } from '@/utils/supabase/server'
import { notFound } from 'next/navigation'
import Header from '@/components/Header'
import Breadcrumb from '@/components/Breadcrumb'
import Footer from '@/components/Footer'

interface GenreLayoutProps {
  children: React.ReactNode
  params: Promise<{ serviceCode: string; id: string }>
}

export default async function GenreLayout({
  children,
  params,
}: GenreLayoutProps) {
  const { serviceCode, id } = await params
  const supabase = await createClient()

  const { data: genre, error } = await supabase
    .from('genres')
    .select('name, code')
    .eq('id', id)
    .single()

  if (error || !genre) {
    notFound()
  }

  const breadcrumbItems = [
    { label: 'トップ', href: `/${serviceCode}` },
    { label: genre.name }
  ]

  return (
    <>
      <Header
        labelText={genre.name || ''}
        pageType="genre-top"
        genreCode={genre.code}
      />
      <div className="hidden md:block md:mt-0">
        <Breadcrumb items={breadcrumbItems} />
      </div>
      {children}
      <Footer pageType="genre-top" genreCode={genre.code} />
    </>
  )
}
